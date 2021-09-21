# Purpose: Downloads and unzips a copy of the Palantir WEF Github Repo. This includes WEF subscriptions and custom WEF channels.

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Downloading and unzipping the Palantir Windows Event Forwarding Repo from Github..."

$wefRepoPath = 'C:\Users\vagrant\AppData\Local\Temp\wef-Master.zip'

If (-not (Test-Path $wefRepoPath))
{
    # This is a bad hack to get it to download through our proxies.  Should download and use proper
    # ca certs but for the purpose of my work this is fine.
    $policy = @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
    
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(ServicePoint srvPoint, X509Certificate certificate, 
                                      WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
    Add-Type -TypeDefinition $policy
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
    # GitHub requires TLS 1.2 as of 2/1/2018
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    # Disabling the progress bar speeds up IWR https://github.com/PowerShell/PowerShell/issues/2138
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri "https://github.com/palantir/windows-event-forwarding/archive/master.zip" -OutFile $wefRepoPath
    Expand-Archive -path "$wefRepoPath" -destinationpath 'c:\Users\vagrant\AppData\Local\Temp' -Force
}
else
{
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) $wefRepoPath already exists. Moving On."
}
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Palantir WEF download complete!"
