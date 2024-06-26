# Chemin de la clé de registre à vérifier
$regPath = "HKLM:\SOFTWARE\SBI"

# Vérifier si la clé de registre VEEAM_MONITORING existe et si sa valeur est 1
$monitoringValue = Get-ItemProperty -Path $regPath -Name "VEEAM_MONITORING" -ErrorAction SilentlyContinue
$webhookUrlValue = Get-ItemProperty -Path $regPath -Name "VEEAM_WEBHOOK" -ErrorAction SilentlyContinue

if ($monitoringValue.VEEAM_MONITORING -eq 1 -and $null -ne $webhookUrlValue.VEEAM_WEBHOOK) {
    # URL du webhook Discord
    $webhookUrl = $webhookUrlValue.VEEAM_WEBHOOK

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # ICONES
    $IconeValide = ":white_check_mark:"
    $IconeWarning = ":warning:"
    $IconeEchec = ":x:"
    $IconeInconnu = ":grey_question:"
   
    # Logiciel recherche
    $LogicielRecherche = "Veeam Backup & Replication Server"
    # Chemin de la clé de registre où se trouvent les informations sur les logiciels installés
    $regPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    # Recherchez le logiciel par nom partiel
    $softwareKeys = Get-ItemProperty -Path $regPath | Where-Object { $_.DisplayName -like "*$LogicielRecherche*" }
    # Solution VEEAM
    $VeeamSolution = $softwareKeys.DisplayName
    # Version de VEEAM
    $VeeamBackupAndReplicationVersion = $softwareKeys.DisplayVersion

    # Variables pour l'embed
    $hostname = $env:COMPUTERNAME
    $time = Get-Date
    $color = 4425837 # Couleur de l'embed en code hexadécimal (ici vert)
    $footerText = "Resultat issu de la solution [Veeam Backup & Replication Server] version [$VeeamBackupAndReplicationVersion]"
    $footerIconURL = "https://aadcdn.msftauthimages.net/dbd5a2dd-92laa6uxe8cm6o2laysa0pnym111fwffj8zubx1pin4/logintenantbranding/0/bannerlogo?ts=638349674629553278"
    $thumbnailURL = "https://upload.wikimedia.org/wikipedia/commons/9/93/Veeam_logo.png"
    $thumbnailURLSuccess = "https://em-content.zobj.net/source/icons8/373/check-mark-button_2705.png"
    $thumbnailURLWarning = "https://em-content.zobj.net/source/apple/125/warning-sign_26a0.png"
    $thumbnailURLFailed = "https://em-content.zobj.net/source/apple/125/cross-mark_274c.png"
    $thumbnailURLNone = "https://em-content.zobj.net/source/apple/28/white-question-mark-ornament_2754.png"

    # Récupération des jobs depuis Veeam
    $jobs = Get-VBRJob

    # Compteurs pour chaque état de job
    $successCount = 0
    $warningCount = 0
    $failedCount = 0
    $noneCount = 0

    # Tableau pour stocker les détails des jobs
    $jobsDetails = @()

    foreach ($job in $jobs) {
        $scheduleOptions = Get-VBRJobScheduleOptions -Job $job
        $nextRun = $scheduleOptions.NextRun
        $nextRunTime = Get-Date $nextRun -Format "HH:mm:ss"

        # Exemple d'utilisation des propriétés du job, à adapter en fonction de vos besoins
        $jobDetails = @{
            Name = $job.Name
            LastState = $job.GetLastState()
            LastResult = $job.GetLastResult()
            Retention_jours = $job.GetOptions().BackupStorageOptions.RetainDaysToKeep
            NextRunTime = $nextRunTime
        }

        # Incrémenter les compteurs en fonction de l'état du job
        switch ($jobDetails.LastResult) {
            "Success" { $successCount++ }
            "Warning" { $warningCount++ }
            "Failed" { $failedCount++ }
            "None" { $noneCount++ }
        }

        # Ajouter les détails du job au tableau
        $jobsDetails += $jobDetails
    }

    # Nombre total de jobs
    $jobNameCount = $jobs.Count

    # Création de l'embed global
    $embedGlobal = @{
        title = "Bilan des sauvegardes de **[$hostname]**"
        description = "- **Total Job(s)** x **$jobNameCount**`n- $IconeValide Succes(s) x **$successCount**`n- $IconeWarning Warning(s) x **$warningCount**`n- $IconeEchec Echec(s) x **$failedCount**`n- $IconeInconnu Inconnu(s) x **$noneCount**`n------------------------------------"
        color = $color
        footer = @{
            text = "Resultats provenant de [$VeeamSolution] version [$VeeamBackupAndReplicationVersion]"
            icon_url = $footerIconURL
        }
        thumbnail = @{
            url = $thumbnailURL
        }
    }

    # Création des embeds détaillés
    $embedsDetailed = @()

    # Fonction pour créer un embed détaillé par statut
    function CreateDetailedEmbed {
        param(
            [string]$authorName,
            [string]$color,
            [object[]]$jobs,
            [string]$thumbnailUrl
        )

        # Trier les jobs par heure de début
        $sortedJobs = $jobs | Sort-Object { [DateTime]::ParseExact($_.NextRunTime, "HH:mm:ss", $null) }

        $fields = @()

        foreach ($job in $sortedJobs) {
            $fieldName = $job.Name
            $fieldValue = "- Statut : [$($job.LastState)]`n- Resultat : [$($job.LastResult)]`n- Retention (jours) : [$($job.Retention_jours)]`n- Heure de debut : [$($job.NextRunTime)]`n---------------------"

            $field = @{
                name = $fieldName
                value = $fieldValue
                inline = $false
            }

            $fields += $field
        }

        return @{
            color = $color
            fields = $fields
            author = @{
                name = $authorName
            }
            thumbnail = @{
                url = $thumbnailUrl  # Utilisez le paramètre $thumbnailUrl pour définir l'URL du thumbnail
            }
        }
    }

    # Créer les embeds détaillés pour chaque statut
    if ($failedCount -gt 0) {
        $embedFailed = CreateDetailedEmbed -authorName "ECHEC" -color 16711680 -jobs ($jobsDetails | where { $_.LastResult -eq 'Failed' }) -thumbnailUrl $thumbnailURLFailed
        $embedsDetailed += $embedFailed
    }
    
    if ($warningCount -gt 0) {
        $embedWarning = CreateDetailedEmbed -authorName "WARNING" -color 13542919 -jobs ($jobsDetails | where { $_.LastResult -eq 'Warning' }) -thumbnailUrl $thumbnailURLWarning
        $embedsDetailed += $embedWarning
    }

    if ($noneCount -gt 0) {
        $embedUnknown = CreateDetailedEmbed -authorName "INCONNU" -color 6250335 -jobs ($jobsDetails | where { $_.LastResult -eq 'None' }) -thumbnailUrl $thumbnailURLNone
        $embedsDetailed += $embedUnknown
    }
    
    if ($successCount -gt 0) {
        $embedSuccess = CreateDetailedEmbed -authorName "SUCCES" -color 638268 -jobs ($jobsDetails | where { $_.LastResult -eq 'Success' }) -thumbnailUrl $thumbnailURLSuccess
        $embedsDetailed += $embedSuccess
    }

    # Construction du body JSON
    $body = @{
        content = $null
        embeds = @($embedGlobal) + $embedsDetailed
        attachments = @()
    } | ConvertTo-Json -Depth 20

    # Vérification du JSON produit
    Write-Output $body

    # Envoi de la requête au webhook Discord
    Invoke-RestMethod -Uri $webhookUrl -Method Post -ContentType "application/json" -Body $body

    Write-Output $body
}
else {
    Write-Output "Conditions non remplies pour exécuter le script."
}
