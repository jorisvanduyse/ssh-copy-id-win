# Ssh-copy-id for windows

## General documentation

It is possible to run the ps1 script without the elevated run.bat script.
This means however that you have to be sure to:

- Set-ExecutionPolicy -ExecutionPolicy Unrestricted
- Have the OpenSSH-client feature installed in apps & features

I compiled the KeySSHCopy.ps1 allready and the sourcecode is available ofcourse. You can also decompile this code easily.

## Compiling KeySSHCopy.ps1 to ssh-copy-id.exe

```ps1
Invoke-ps2exe -version '0.1' -title 'ssh-copy-id' -requireAdmin .\KeySSHCopy.ps1 .\ssh-copy-id.exe -verbose
```

## Decompiling ssh-copy-id.exe

```ps1
ssh-copy-id.exe -extract:$home\Desktop\KeySSHCopy.ps1
```
