# ____  __  _  _  ____  __    ____    ____   __    ___  __ _  _  _  ____ 
# / ___)(  )( \/ )(  _ \(  )  (  __)  (  _ \ / _\  / __)(  / )/ )( \(  _ \
# \___ \ )( / \/ \ ) __// (_/\ ) _)    ) _ (/    \( (__  )  ( ) \/ ( ) __/
# (____/(__)\_)(_/(__)  \____/(____)  (____/\_/\_/ \___)(__\_)\____/(__)  
#                                                   by ixale https://github.com/5ubh4d45

# - to run the script on PowerShell, use ". <path to the script>\BackupController.ps1; <Command of Your Choice>"
# - Current Choices [Backup, Restore, BackupAndCommit(WIP)]
# - example1 in Ps > . .\BackupController.ps1; Backup 
# - example2 in Ps > . $HOME\Desktop\BackupController.ps1; Restore 
# - HERE "." and "HOME\Desktop\" are the path to the script.

#----------------------------------------------------------------------------------------------------------------------#

# Backup script for settings of my terminals

# declaring paths for sources
$sourcePowerShellPath = "$HOME\Documents\PowerShell"                                # change your powershell path
$sourceWindowsTerminalPath = "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"     # change according to your winTerminal location
$sourceUbuntuHomePath = "\\wsl$\Ubuntu\home\ixale"                        # change accroding to your wsl ubuntu Home

$pathsList = $sourcePowerShellPath, $sourceWindowsTerminalPath, $sourceUbuntuHomePath


# backup folders to save and organize files
$backupRootPath = "$HOME\Documents\Various-Settings-Backups"        # change your backup root folder
$backupPowershellPath = $backupRootPath +"\Powershell"              # change according to paths
$backupWindowsTerminalPath = $backupRootPath +"\WindowsTerminal"    # change according to paths
$backupUbuntuHomePath = $backupRootPath +"\UbuntuHome"              # change according to paths

# list of objects to backup for each backups
$powerShellItems = 'Microsoft.PowerShell_profile.ps1'               # add stuffs you want to backup
$windosTerminalItems = 'settings.json', 'state.json'                # add stuffs you want to backup
$ubuntuHomeItems = '.gitconfig', '.profile', 'banner', 'now'        # add stuffs you want to backup


# check paths
foreach ($path in $pathsList) {
    if (!(Test-Path -PathType Container $path)) {
        Write-Error -Message "Backup Source Path: " + $path + " Does not Exists!!"
        
    }
}


function copyItems {
    param (
        [Parameter(Mandatory = $true)] [string]
        $sourcePath,
        [Parameter(Mandatory = $true)] [string]
        $backupPath,
        [Parameter(Mandatory = $true)]
        $itemsList
    )
    # testing backup paths exists of not 
    If (!(Test-Path -PathType container $backupPath)){
        New-Item -ItemType Directory -Path $backupPath
    }

    # copies the files
    foreach ($item in $itemsList) {
        $actualPath = $sourcePath + "\" + $item
        Write-Host Backing up $item to $backupPath

        Copy-Item -Path $actualPath -Destination $backupPath
    }
}

# TODO: adding git full integration

# test
# function Test {
#     Write-Host Successfull.
# }

# backing up
function Backup {        
    # powershell
    copyItems $sourcePowerShellPath $backupPowershellPath $powerShellItems

    # windows terminal
    copyItems $sourceWindowsTerminalPath $backupWindowsTerminalPath $windosTerminalItems

    # ubuntu
    copyItems $sourceUbuntuHomePath $backupUbuntuHomePath $ubuntuHomeItems

    Write-Host Backup Successfull.

}
# restore
function Restore {        
    # powershell
    copyItems $backupPowershellPath $sourcePowerShellPath $powerShellItems

    # windows terminal
    copyItems $backupWindowsTerminalPath $sourceWindowsTerminalPath $windosTerminalItems

    # ubuntu
    copyItems $backupUbuntuHomePath $sourceUbuntuHomePath $ubuntuHomeItems

    Write-Host Restore Successfull.
}

# backup and commit
function BackupAndCommit {
    param (
        [Parameter(Mandatory = $true)] [string]
        $commitMessage
    )
    Backup
    # git init
    git add *
    if ($commitMessage) {
        <# Action to perform if the condition is true #>
        git commit -m $commitMessage
    }
    
}
