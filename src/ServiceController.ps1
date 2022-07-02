. "$PSScriptRoot\Tools.ps1"

# Outputs a line of a ServiceController
function Write-Color-Service
{
    param ([string]$color, $service)

    Write-HostANSI -Content ("{0,-8}" -f $_.Status) -Color $color -NoNewline
    Write-HostANSI -Content (" {0,-18} {1,-39}" -f (CutString $_.Name 18), (CutString $_.DisplayName 38)) -Color $global:PSColor.Service.Default.ANSI
}

function ServiceController {
    param (
        [Parameter(Mandatory=$True,Position=1)]
        $service
    )

    if($script:showHeader)
    {
       Write-Host
       Write-Host "Status   Name               DisplayName"
       $script:showHeader=$false
    }

    if ($service.Status -eq 'Stopped')
    {
        Write-Color-Service $global:PSColor.Service.Stopped.ANSI $service
    }
    elseif ($service.Status -eq 'Running')
    {
        Write-Color-Service $global:PSColor.Service.Running.ANSI $service
    }
    else {
        Write-Color-Service $global:PSColor.Service.Default.ANSI $service
    }
}
