#Requires -RunAsAdministrator

# If Get-ExecutionPolicy is restricted change boolean (for later change back to default) than change settings temporary:
$exEecPol =  Get-ExecutionPolicy

if ($exEecPol -match " Restricted ") {
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted
    if (!$?) { Write-Host "============+++ Failed to change exexpol to Unrestricted   +++============`n" }
    else  { Write-Host "============+++   Changed exexpol to Unrestricted   +++============`n" }
}

# You need the openSSH-client feature: ms-settings:optionalfeatures
ssh -V
if (!$?) {
    Write-Host "`nFailed to start openSSH-client `nInstall openSSH-client via the opened settings screen and Continue `nOR YOU COULD TRY TO CONTINUE"
    start ms-settings:optionalfeatures
    
    while ($restart -notmatch 'y') {
        $restart = Read-Host -Prompt "Continue (y)? "
        ssh -V
    }

}

# Get ssh public key
$PublicKey = Get-Content $home/.ssh/id_rsa.pub
if ($PublicKey -eq $null) {
    Write-Host "`n============+++         No public key found           +++============"
    $choiceSHHKeygen = Read-Host -Prompt "Generate new keypair (y)?"
} else {
    Write-Host "`n============+++            Public key found           +++============`n$PublicKey"
    $choiceSHHKeygen = Read-Host -Prompt "Generate new keypair (y) or use this key: id_rsa.pub (d)? "
}

# Run ssh-keygen to create a key pair or use the existing key
if ($choiceSHHKeygen -match 'y') {
    ssh-keygen
    $choiceCustomName = Read-Host -Prompt "Did you add a custom name (n / [path + custom name])?"
    if ($choiceCustomName -notmatch 'n') {
        $PublicKeyName = $choiceCustomName + ".pub"
        $PublicKey = Get-Content $PublicKeyName
    }
}

# Get SSH username and server adress
if ($?) { # If the last command did not cause a crash
    Write-Host "============+++     Connecting to SSH server      +++============"
    $user = Read-Host -Prompt "Enter the username (username)"
    $Server = Read-Host -Prompt "Enter the servername (example.com)"

# Copy key to ssh server
    Write-Host "============+++ Copying public key to $user@$Server +++============"
    ssh $user@$Server "echo $PublicKey >> ~/.ssh/authorized_keys"
} else {
    $choiceRestart = Read-Host -Prompt "Faield to use the key; restart the program? (y / n)"
    if ($choiceRestart -match 'y') {
        .\run.bat
    } else {
        $ThereWasAnError = 1
    }
}

# Check if there was an error
if ($?) { 
    Write-Host "Success"
} else {
    Write-Host "An error occurred while copying the ssh key to the server"
}
Start-Sleep 2

# Change old settings back
if ($exEecPol -match "Restricted") {
    Set-ExecutionPolicy -ExecutionPolicy $exEecPol
    Write-Host "`n============+++ Changed Policy back to default    +++============"
}