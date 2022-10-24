# PowerShell execution policy needs to be set to unrestricted (Set-ExecutionPolicy Unrestricted) before execution
# Return to remote-signed when done (Set-ExecutionPolicy RemoteSigned)

$path = "C:\ProgramData\Audinate\Dante Virtual Soundcard\manager.json"

#Exit with error if path does not exist
if(-not (Test-Path $path))
{throw "Script could not be executed since following path does not exist: " + $path}

#Exit with error if dvs.manager is not running
if(-not ((Get-Service -Name dvs.manager).status -eq "Running"))
{throw "The service dvs.manager is not running yet. Please wait for the service to start before executing."}

#This get executed if path is valid and service is running
$a = Get-Content $path -raw | ConvertFrom-Json
        
if($a.WantToRun -eq $true)
    {
        $a.WantToRun = $false
        $a | ConvertTo-Json | Set-Content $path

        Restart-Service -Name dvs.manager

        echo "DVS has been stopped"
    }
else
    {
        echo "DVS is already stopped. No action executed."
    }
