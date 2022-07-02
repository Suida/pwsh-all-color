. "$PSScriptRoot\Tools.ps1"

function PrintContext(){
    param (
    [Parameter(Mandatory=$True)]
    $display, 
    [Parameter(Mandatory=$True)]
    $filename, 
    [Parameter(Mandatory=$True)]
    $start
    )
    $display | foreach { 
        Write-HostANSI -Content "  ${filename}" -Color $global:PSColor.NoMatch.Path.ANSI  -NoNewline
        Write-HostANSI -Content ":" -Color $global:PSColor.NoMatch.Default.ANSI  -NoNewline
        Write-HostANSI -Content "$start" -Color $global:PSColor.NoMatch.LineNumber.ANSI  -NoNewline
        Write-HostANSI -Content ":" -Color $global:PSColor.NoMatch.Default.ANSI  -NoNewline
        Write-HostANSI -Content "$_" -Color $global:PSColor.NoMatch.Line.ANSI 
        $start++ 
    }
}

function MatchInfo {
    param (
        [Parameter(Mandatory=$True,Position=1)]
        $match
    )
    
    if ($match.Context) {PrintContext $match.Context.DisplayPreContext $match.RelativePath($pwd) ($match.LineNumber - $match.Context.DisplayPreContext.Count)}
    Write-HostANSI -Content '> ' -Color $global:PSColor.Match.Default.ANSI  -NoNewline
    Write-HostANSI -Content $match.RelativePath($pwd) -Color $global:PSColor.Match.Path.ANSI  -NoNewline
    Write-HostANSI -Content ':' -Color $global:PSColor.Match.Default.ANSI  -NoNewline
    Write-HostANSI -Content $match.LineNumber -Color $global:PSColor.Match.LineNumber.ANSI  -NoNewline
    Write-HostANSI -Content ':' -Color $global:PSColor.Match.Default.ANSI  -NoNewline
    Write-HostANSI -Content $match.Line -Color $global:PSColor.Match.Line.ANSI 
    if ($match.Context) {PrintContext $match.Context.DisplayPostContext $match.RelativePath($pwd) ($match.LineNumber + 1)}
}

# %s/[Ww]rite-[Hh]ost\s*\(.\{-\}\)\s-[fF]oreground[Cc]olor\s*\(.\{-\}\)\.Color\(.*\)/Write-HostANSI -Content \1 -Color \2.ANSI \3/
