<#
.SYNOPSIS
    Converts a CAA record's RDATA from hex format to a readable format.

.DESCRIPTION
    This function takes a CAA record's RDATA in hex format (as returned by DNS queries) and converts it into a readable format, extracting the flags, tag, and value.

.EXAMPLE
    Convert-CaaRdata -HexData "\# 19 00 05 69 73 73 75 65 64 69 67 69 63 65 72 74 2e 63 6f 6d"
#>
function Convert-CaaRdata {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$HexData
    )

    # Strip the "\# 19 " prefix (length byte) if present, keep only hex pairs
    $hexBytes = ($HexData -replace '^\\#\s*\d+\s*', '') -split '\s+' | Where-Object { $_ }
    $bytes = $hexBytes | ForEach-Object { [Convert]::ToByte($_, 16) }

    $flags = $bytes[0]
    $tagLen = $bytes[1]
    $tag = -join ($bytes[2..(1 + $tagLen)] | ForEach-Object { [char]$_ })
    $value = -join ($bytes[(2 + $tagLen)..($bytes.Length - 1)] | ForEach-Object { [char]$_ })

    [PSCustomObject]@{
        Flags = $flags
        Tag   = $tag
        Value = $value
    }
}