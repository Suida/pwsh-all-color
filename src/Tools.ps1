$ConsoleColorNames = [Enum]::GetNames([System.ConsoleColor])
$RGBHex = New-Object System.Text.RegularExpressions.Regex('#[0-9a-fA-F]{6}')

function Get-RGB() {
    Param (
        [Parameter(Mandatory)]
        [string]
        $Color
    )

    $rgb = ''
    if ($Color -in $ConsoleColorNames) {
        $pwshcolor = [System.Drawing.Color]::FromName($Color)
        $rgb = ("{0};{1};{2}" -f $pwshcolor.R, $pwshcolor.G, $pwshcolor.B)
    } elseif ($RGBHex.IsMatch($Color)) {
        $rgb = (
            "{0};{1};{2}" -f
            [Int32]('0x' + $Color.Substring(1,2)),
            [Int32]('0x' + $Color.Substring(3,2)),
            [Int32]('0x' + $Color.Substring(5,2))
        )
    } else {
        Throw (
            "Invalid color value: {0}. Only hexdecimal RGB value (for example, #ff0000)`n" +
            "and console colors (see ``[Enum]::GetNames([System.ConsoleColor])``)`n" +
            "are supported" -f $Color
        )
    }
    return $rgb
}

function ColorToANSI() {
    Param (
        [Parameter(Mandatory)]
        [string]
        $Color
    )

    $rgb = Get-RGB -color $Color
    return ("`e[38;2;{0}m" -f $rgb) 
}

function Set-PSColor() {
    Param (
        [Parameter(Mandatory)]
        [hashtable]
        $PSColor
    )
    foreach($item in $PSColor.GetEnumerator()) {
        foreach($subitem in $item) {
            foreach($pair in $subitem.Value.GetEnumerator()) {
                $ansi = ColorToANSI -color $pair.Value.Color
                $subitem.Value[$pair.Name]['ANSI'] = $ansi
            }
        }
    }
}

function Write-HostANSI() {
    Param (
        [Parameter(Mandatory)]
        [string]
        $Content,
        [string]
        $Color,
        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Remaining
    )
    echo fuck

    $expr = "Write-Host `"$Color$Content`" " + ($Remaining -Join " ")
    Invoke-Expression $expr
}

Export-ModuleMember -Function Set-PSColor, Write-HostANSI
