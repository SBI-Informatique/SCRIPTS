#--------------------------------------------------------------------------------------------------------------------------
#1/ VARIABLES :
#--------------------------------------------------------------------------------------------------------------------------
# VARIABLES
    $PATH_OPENVPN = "C:\SBI\OPENVPN"
    $PATH_OPENVPN_MSI = "C:\SBI\OPENVPN\OPENVPN.msi"
    $PATH_OPENVPN_ZIP = "C:\SBI\OPENVPN\OPENVPN.zip"
    $PATH_7ZIP_PROGRAMME = "C:\Program Files\7-Zip\7z.exe"

#--------------------------------------------------------------------------------------------------------------------------
#2/ TELECHARGEMENT DE LA SOURCE :
#--------------------------------------------------------------------------------------------------------------------------
If(!(test-path $PATH_OPENVPN))
{
    #1/ Création du répertoire OPENVPN
    mkdir C:\SBI\OPENVPN

    #2/ Création du répertoire OPENVPN
    mkdir C:\SBI\7ZIP
   
    #3/ Import du module BITSTRANSFER
    Import-Module BitsTransfer

    #4/ Telechargement de OPENVPN
    Start-BitsTransfer http://sbiinforkw.cluster020.hosting.ovh.net/Applications/OPENVPN/OPENVPN.zip C:/SBI/OPENVPN/OPENVPN.zip

    #5/ Telechargement de 7ZIP
    Start-BitsTransfer http://sbiinforkw.cluster020.hosting.ovh.net/Applications/7ZIP/7zip.exe C:/SBI/7ZIP/7zip.exe
}

#--------------------------------------------------------------------------------------------------------------------------
#3/ INSTALLATION DU PROVIDER (nuget)
#--------------------------------------------------------------------------------------------------------------------------
If(!(Get-PackageProvider -ListAvailable -Name Nuget)) # Est-ce que le provider existe déja ?
    {
        Install-PackageProvider -Name Nuget -MinimumVersion 2.8.5.201 -Force
    }

#--------------------------------------------------------------------------------------------------------------------------
#4/ INSTALLATION DE 7ZIP (module Powershell) :
#--------------------------------------------------------------------------------------------------------------------------
If(!(Get-Module -ListAvailable -Name 7Zip4Powershell)) # Est-ce que le module existe déja ?
    {
        Install-Module 7Zip4PowerShell -Force
    }

#--------------------------------------------------------------------------------------------------------------------------
#5/ EXTRACTION OPENVPN.ZIP :
#--------------------------------------------------------------------------------------------------------------------------
If((test-path $PATH_OPENVPN_ZIP))
    {
        #3/ Extraction du fichier ZIP OPENVPN
        Expand-7Zip -ArchiveFileName $PATH_OPENVPN_ZIP -TargetPath $PATH_OPENVPN
        rm $PATH_OPENVPN_ZIP
    }

#--------------------------------------------------------------------------------------------------------------------------
#6/ INSTALATION DE OPENVPN :
#--------------------------------------------------------------------------------------------------------------------------
 If((test-path $PATH_OPENVPN_MSI))
    {
        #3/ Extraction du fichier ZIP OPENVPN
        msiexec.exe /i $PATH_OPENVPN_MSI /qn
    }
#--------------------------------------------------------------------------------------------------------------------------
