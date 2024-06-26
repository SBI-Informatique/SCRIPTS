# Chemin de la clé de registre à vérifier
$regPath = "HKLM:\SOFTWARE\SBI"

# Vérifier si la clé de registre VEEAM365_MONITORING existe et si sa valeur est 1
$monitoringValue365 = Get-ItemProperty -Path $regPath -Name "VEEAM365_MONITORING" -ErrorAction SilentlyContinue
$webhookUrlValue365 = Get-ItemProperty -Path $regPath -Name "VEEAM365_WEBHOOK" -ErrorAction SilentlyContinue

if ($monitoringValue365.VEEAM365_MONITORING -eq 1 -and $null -ne $webhookUrlValue365.VEEAM365_WEBHOOK) {
    # URL du webhook Discord
    $webhookUrl365 = $webhookUrlValue365.VEEAM365_WEBHOOK

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # ICONES
    $IconeValide = ":white_check_mark:"
    $IconeWarning = ":warning:"
    $IconeEchec = ":x:"
    $IconeInconnu = ":grey_question:"
    $IconeRunning = ":hourglass_flowing_sand:"
   
    # Logiciel recherche
    $LogicielRecherche365 = "Veeam Backup for Microsoft 365"
    # Chemin de la clé de registre où se trouvent les informations sur les logiciels installés
    $regPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    # Recherchez le logiciel par nom partiel
    $softwareKeys365 = Get-ItemProperty -Path $regPath | Where-Object { $_.DisplayName -like "*$LogicielRecherche365*" }
    # Solution VEEAM
    $VeeamSolution365 = $softwareKeys365.DisplayName
    # Version de VEEAM
    $Veeam365Version = $softwareKeys365.DisplayVersion

    # Variables pour l'embed
    $hostname = $env:COMPUTERNAME
    $time = Get-Date
    $color = 4425837 # Couleur de l'embed en code hexadécimal (ici vert)
    $footerText = "Resultat issu de la solution [$VeeamSolution365] version [$Veeam365Version]"
    $footerIconURL = "https://aadcdn.msftauthimages.net/dbd5a2dd-92laa6uxe8cm6o2laysa0pnym111fwffj8zubx1pin4/logintenantbranding/0/bannerlogo?ts=638349674629553278"
    $thumbnailURL = "https://upload.wikimedia.org/wikipedia/commons/9/93/Veeam_logo.png"
    $thumbnailURLSuccess = "https://em-content.zobj.net/source/icons8/373/check-mark-button_2705.png"
    $thumbnailURLWarning = "https://em-content.zobj.net/source/apple/125/warning-sign_26a0.png"
    $thumbnailURLFailed = "https://em-content.zobj.net/source/apple/125/cross-mark_274c.png"
    $thumbnailURLNone = "https://em-content.zobj.net/source/apple/28/white-question-mark-ornament_2754.png"
    $thumbnailURLRunning = "https://em-content.zobj.net/source/apple/81/hourglass-with-flowing-sand_23f3.png"

    # Récupération des jobs depuis Veeam
    $jobs365 = Get-VBOJob

    # Récupération de toutes les sessions de sauvegarde
    $Job365Sessions = Get-VBOJobSession

    # Compteurs pour chaque état de job
    $success365Count = 0
    $warning365Count = 0
    $failed365Count = 0
    $none365Count = 0
    $running365Count = 0

    # Tableau pour stocker les détails des jobs
    $jobs365Details = @()

    foreach ($job365 in $jobs365) {
        $nextRun365 = $job365.NextRun
        $nextRun365Time = $nextRun365.ToString("dd/MM/yyyy HH:mm:ss")
    
        # Exemple d'utilisation des propriétés du job, à adapter en fonction de vos besoins
        $job365Details = @{
            Name = $job365.Name
            LastStatus = $job365.LastStatus
            LastRun = $job365.LastRun.ToString("dd/MM/yyyy HH:mm:ss")
            NextRunTime = $nextRun365Time
        }
    
        # Incrémenter les compteurs en fonction de l'état du job
        switch ($job365Details.LastStatus) {
            "Success" { $success365Count++ }
            "Warning" { $warning365Count++ }
            "Failed" { $failed365Count++ }
            "None" { $none365Count++ }
            "Running" { $running365Count++ }
        }
    
        # Ajouter les détails du job au tableau
        $jobs365Details += $job365Details
    }

    # Création de l'embed global
    $embedGlobal365 = @{
        title = "Bilan des sauvegardes 365 de **[$hostname]**"
        description = "- **Total Job(s)** x **$jobName365Count**`n- $IconeValide Succes(s) x **$success365Count**`n- $IconeWarning Warning(s) x **$warning365Count**`n- $IconeEchec Echec(s) x **$failed365Count**`n- $IconeInconnu Inconnu(s) x **$none365Count**`n- $IconeRunning En cour(s) x **$running365Count**`n------------------------------------"
        color = $color
        footer = @{
            text = $footerText
            icon_url = $footerIconURL
        }
        thumbnail = @{
            url = $thumbnailURL
        }
    }

    # Création des embeds détaillés
    $embeds365Detailed = @()

    # Fonction pour créer un embed détaillé par statut
    function CreateDetailedEmbed {
        param(
            [string]$authorName,
            [string]$color,
            [object[]]$jobs,
            [string]$thumbnailUrl
        )
    
        # Trier les jobs par heure de début
        $sorted365Jobs = $jobs | Sort-Object { [DateTime]::ParseExact($_.NextRunTime, "dd/MM/yyyy HH:mm:ss", $null) }
    
        $fields = @()
    
        foreach ($job365 in $sorted365Jobs) {
            $fieldName = $job365.Name
            $fieldValue = "- Resultat : [$($job365.LastStatus)]`n- Derniere execution : [$($job365.LastRun)]`n- Prochaine execution : [$($job365.NextRunTime)]`n---------------------"
    
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
    if ($failed365Count -gt 0) {
        $embedFailed = CreateDetailedEmbed -authorName "ECHEC" -color 16711680 -jobs ($jobs365Details | Where-Object { $_.LastStatus -eq 'Failed' }) -thumbnailUrl $thumbnailURLFailed
        $embeds365Detailed += $embedFailed
    }
    
    if ($warning365Count -gt 0) {
        $embedWarning = CreateDetailedEmbed -authorName "WARNING" -color 13542919 -jobs ($jobs365Details | Where-Object { $_.LastStatus -eq 'Warning' }) -thumbnailUrl $thumbnailURLWarning
        $embeds365Detailed += $embedWarning
    }

    if ($none365Count -gt 0) {
        $embedUnknown = CreateDetailedEmbed -authorName "INCONNU" -color 6250335 -jobs ($jobs365Details | Where-Object { $_.LastStatus -eq 'None' }) -thumbnailUrl $thumbnailURLNone
        $embeds365Detailed += $embedUnknown
    }
        if ($running365Count -gt 0) {
        $embedWarning = CreateDetailedEmbed -authorName "RUNNING" -color 13542919 -jobs ($jobs365Details | Where-Object { $_.LastStatus -eq 'Running' }) -thumbnailUrl $thumbnailURLRunning
        $embeds365Detailed += $embedWarning
    }
    
    if ($success365Count -gt 0) {
        $embedSuccess = CreateDetailedEmbed -authorName "SUCCES" -color 638268 -jobs ($jobs365Details | Where-Object { $_.LastStatus -eq 'Success' }) -thumbnailUrl $thumbnailURLSuccess
        $embeds365Detailed += $embedSuccess
    }


    # Construction du body JSON
    $body = @{
        content = $null
        embeds = @($embedGlobal365) + $embeds365Detailed
        attachments = @()
    } | ConvertTo-Json -Depth 20

    # Vérification du JSON produit
    Write-Output $body

    # Envoi de la requête au webhook Discord
    Invoke-RestMethod -Uri $webhookUrl365 -Method Post -ContentType "application/json" -Body $body

} else {
    Write-Output "Conditions non remplies pour exécuter le script."
}
