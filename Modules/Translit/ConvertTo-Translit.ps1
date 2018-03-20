﻿#PowerShell
#Requires -Version 3.0


function ConvertTo-Translit {
    <#
    .SYNOPSIS
        Function for transliteration russian symbols with standards and rules.

    .DESCRIPTION
        Function for transliteration russian symbols with standards and rules.
        .

    .PARAMETER String
        String for transliteration.

    .PARAMETER Standard
        Standard name for transliteration.

    .LINK
        https://github.com/alseg/ConvertTo-Translit

    .NOTES
        .

    .EXAMPLE
        PS> ConvertTo-Translit -String "Иванов Пётр Геннадьевич" -Standard gost-r-52535.1-2006
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory,
        ValueFromPipeline,
        HelpMessage = "Enter string for transliteration")]
        [String]
        $String,

        [Parameter()]
        [ValidateSet("bgn-pcgn-1947", "gost-r-52535.1-2006")]
        [String]
        $Standard = "bgn-pcgn-1947",

        [Parameter()]
        [ValidateSet("Uppercase", "Lowercase", "Capitalize")]
        [String]
        $Format = "Capitalize"
    )

    Begin {
        $BGN_PCGN_1947 = @{
            "А" = "A"
            "Б" = "B"
            "В" = "V"
            "Г" = "G"
            "Д" = "D"
            "Е" = "E"
            "Ё" = "E"
            "Ж" = "ZH"
            "З" = "Z"
            "И" = "I"
            "Й" = "Y"
            "К" = "K"
            "Л" = "L"
            "М" = "M"
            "Н" = "N"
            "О" = "O"
            "П" = "P"
            "Р" = "R"
            "С" = "S"
            "Т" = "T"
            "У" = "U"
            "Ф" = "F"
            "Х" = "KH"
            "Ц" = "TS"
            "Ч" = "CH"
            "Ш" = "SH"
            "Щ" = "SHCH"
            "Ь" = ""
            "Ы" = "Y"
            "Ъ" = ""
            "Э" = "E"
            "Ю" = "YU"
            "Я" = "YA"
            "ЬЕ" = "YE"
        }

        $GOST_R_52535_1_2006 = @{
            "А" = "A"
            "Б" = "B"
            "В" = "V"
            "Г" = "G"
            "Д" = "D"
            "Е" = "E"
            "Ё" = "E"
            "Ж" = "ZH"
            "З" = "Z"
            "И" = "I"
            "Й" = "I"
            "К" = "K"
            "Л" = "L"
            "М" = "M"
            "Н" = "N"
            "О" = "O"
            "П" = "P"
            "Р" = "R"
            "С" = "S"
            "Т" = "T"
            "У" = "U"
            "Ф" = "F"
            "Х" = "KH"
            "Ц" = "TC"
            "Ч" = "CH"
            "Ш" = "SH"
            "Щ" = "SHCH"
            "Ь" = ""
            "Ы" = "Y"
            "Ъ" = ""
            "Э" = "E"
            "Ю" = "IU"
            "Я" = "IA"
            "ЬЕ" = "E"
        }
    }

    Process {
        Switch($Standard) {
            "bgn-pcgn-1947" {
                [Hashtable]$SelectedStandardSet = $BGN_PCGN_1947
            }
            "gost-r-52535.1-2006" {
                [Hashtable]$SelectedStandardSet = $GOST_R_52535_1_2006
            }
        }

        [Array]$NewString, [Array]$NewWordArray = @()
        [Array]$String = $String.Split(" ")

        ForEach ($Word in $String) {
            ForEach ($Char in $Word.ToCharArray()) {
                If (($Char -eq "Е") -and ($Previous -eq "Ь")) {
                    $NewWordArray += $SelectedStandardSet["ЬЕ"]
                }
                Else {
                    $NewWordArray += $SelectedStandardSet["$Char"]
                }
                [String]$Previous = $Char
            }
            [String]$WordCommit = $NewWordArray -join ""
            [Array]$StringCommit += $WordCommit
            $NewWordArray = @()
            $WordCommit = @()
        }

        $Result = $StringCommit -join " "

        Switch($Format) {
            "Uppercase" {
                $Result = $Result.ToUpper()
            }
            "Lowercase" {
                $Result = $Result.ToLower()
            }
            "Capitalize" {
                $Result = (Get-Culture).TextInfo.ToTitleCase($Result.ToLower())
            }
        }

        $Result
    }
}
