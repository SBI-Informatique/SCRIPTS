# Définir le chemin de la clé de registre
$regPath = "HKLM:\SOFTWARE\SBI"

# Lire la valeur de la clé de registre DISCORD
$discordUrl = (Get-ItemProperty -Path $regPath -Name "DISCORD").DISCORD
$webhookUrl = $discordUrl

# Lire la valeur de la clé de registre CONNEXION
$connexionValue = (Get-ItemProperty -Path $regPath -Name "CONNEXION").CONNEXION

# Vérifier si la valeur de CONNEXION est à 1
if ($connexionValue -eq 1) {
    # Liste des EventIDs à surveiller
    $eventIDs = @(22, 25)

    # Définir la date limite pour les événements (1 dernier jour)
    $dateLimite = (Get-Date).AddDays(-1)

    # Initialiser les variables pour l'événement le plus récent
    $latestEvent = $null
    $latestEventID = $null

    # Parcourir les EventIDs spécifiés
    foreach ($eventID in $eventIDs) {
        # Filtrer les événements par EventID et date limite, puis trier par ordre chronologique décroissant
        $events = Get-WinEvent -LogName "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational" `
                               -FilterXPath "*[System[(EventID=$eventID)]]" |
                  Where-Object { $_.TimeCreated -ge $dateLimite } |
                  Sort-Object TimeCreated -Descending |
                  Select-Object -First 1

        if ($events) {
            # Si un événement est trouvé, le définir comme l'événement le plus récent
            $latestEvent = $events
            $latestEventID = $eventID
        }
    }

    if ($latestEvent) {
        $eventXML = [xml]$latestEvent.ToXml()
        $RDP_User = $eventXML.Event.UserData.EventXML.User
        $RDP_IP_Source = $eventXML.Event.UserData.EventXML.Address
        $RDP_Heure_Date = [datetime]::Parse($eventXML.Event.System.TimeCreated.SystemTime).ToString("dd/MM/yyyy HH:mm:ss")

        # Créer le JSON
        $jsonContent = @{
            content = $null
            embeds = @(
                @{
                    title = "Connexion distante"
                    color = 1788072
                    fields = @(
                        @{
                            name = ":calendar: Date et Heure :"
                            value = "$RDP_Heure_Date"
                        }
                        @{
                            name = ":man_pouting: Utilisateur :"
                            value = "$RDP_User"
                        }
                        @{
                            name = ":computer: Adresse IP d'origine :"
                            value = "$RDP_IP_Source"
                        }
                    )
                    thumbnail = @{
                        url = "https://img.icons8.com/?size=77&id=8kpqNWqschXX&format=png"
                    }
                }
            )
            attachments = @()
        } | ConvertTo-Json -Depth 4

        # Envoyer le JSON au webhook
        $headers = @{
            "Content-Type" = "application/json"
        }

        try {
            $response = Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $jsonContent -Headers $headers
            Write-Output "Success: $response"
        } catch {
            Write-Error "Failed to send JSON: $_"
        }

        # Afficher les informations de connexion récapitulatives
        $info = "EventID: $latestEventID, Utilisateur : $RDP_User, Adresse : $RDP_IP_Source, Heure de connexion : $RDP_Heure_Date"
        $JournauxDeConnexions = "------`n$info`n------"
        Write-Host $JournauxDeConnexions

        # Remettre la valeur de CONNEXION à 0 après l'envoi
        Set-ItemProperty -Path $regPath -Name "CONNEXION" -Value 0 -Force
        Write-Host "Valeur CONNEXION remise à 0"
    } else {
        Write-Output "Aucun événement RDP trouvé pour les EventIDs 22 ou 25 dans les dernières 24 heures."
    }
} else {
    Write-Host "La valeur de CONNEXION n'est pas à 1. Le JSON ne sera pas envoyé."
}
