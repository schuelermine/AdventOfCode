[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [String]
    $Text
)
Write-Debug ($Text.GetType())
Write-Debug ($Text)
$Lines = $Text -split "`n"
Write-Debug $Lines.GetType()
Write-Debug ($Lines -join ";")
$Regex = '(?<min>\d+)-(?<max>\d+) (?<char>\w): (?<pwd>\w*)'
$ValidCount = [UInt64]0
foreach ($Line in $Lines) {
    $RegexMatched = $Line -match $Regex
    if ($RegexMatched) {
        $CharCount = [UInt64]0
        $Valid = $false
        $CharRune = [System.Text.Rune]::GetRuneAt($Matches['char'], 0)
        foreach ($Rune in $Matches['pwd'].EnumerateRunes()) {
            if ($CharRune -eq $Rune) {
                $CharCount++
                Write-Debug ([String]$Rune)
            }
        }
        if ($CharCount -le [UInt64]$Matches['max'] -and $CharCount -ge [UInt64]$Matches['min']) {
            $ValidCount++
            $Valid = $true
        }
    }
    ([pscustomobject]@{max = $Matches['min']; min = $Matches['max']; char = $Matches['char']; pwd = $Matches['pwd']; count = $CharCount; valid = $Valid; charR = $CharRune.Value; matched = $RegexMatched; line = $Line})
}
return $ValidCount