
Add-Type -assemblyname System.ServiceProcess

. "$PSScriptRoot\PSColorHelper.ps1"
. "$PSScriptRoot\FileInfo.ps1"
. "$PSScriptRoot\ServiceController.ps1"
. "$PSScriptRoot\MatchInfo.ps1"
. "$PSScriptRoot\ProcessInfo.ps1"
. "$PSScriptRoot\Tools.ps1"

$global:PSColor = @{
    File = @{
        Default    = @{ Color = 'Black' }
        Directory  = @{ Color = 'Cyan'}
        Hidden     = @{ Color = 'DarkGray'; Pattern = '^\.' } 
        Code       = @{ Color = 'Magenta'; Pattern = '\.(java|c|cpp|cs|js|css|html)$' }
        Executable = @{ Color = 'Red'; Pattern = '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$' }
        Text       = @{ Color = 'Yellow'; Pattern = '\.(txt|cfg|conf|ini|csv|log|config|xml|yml|md|markdown)$' }
        Compressed = @{ Color = 'Green'; Pattern = '\.(zip|tar|gz|rar|jar|war|7z)$' }
    }
    Service = @{
        Default = @{ Color = 'Black' }
        Running = @{ Color = 'DarkGreen' }
        Stopped = @{ Color = 'DarkRed' }     
    }
    Match = @{
        Default    = @{ Color = 'Black' }
        Path       = @{ Color = 'Cyan'}
        LineNumber = @{ Color = 'Yellow' }
        Line       = @{ Color = 'Black' }
    }
	NoMatch = @{
        Default    = @{ Color = 'Black' }
        Path       = @{ Color = 'Cyan'}
        LineNumber = @{ Color = 'Yellow' }
        Line       = @{ Color = 'Black' }
    }
}

Set-PSColor($global:PSColor)

$script:showHeader=$true

New-CommandWrapper Out-Default -Process {

    if(($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo]))
    {
        FileInfo $_
        $_ = $null
    }

    elseif($_ -is [System.ServiceProcess.ServiceController])
    {
        ServiceController $_
        $_ = $null
    }

    elseif($_ -is [Microsoft.Powershell.Commands.MatchInfo])
    {
        MatchInfo $_
        $_ = $null
    }
} -end {
    write-host ""
    $script:showHeader=$true
}

Export-ModuleMember -Function Set-PSColor, Write-HostANSI
