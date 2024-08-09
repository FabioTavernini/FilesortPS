<#
.SYNOPSIS
    A script to check for duplicate files in multiple directories.
.DESCRIPTION
    Select folder with FolderBrowserDialog, then get all elements inside the folder and check the file hashes.
    If the hashes match, return the filenames that are a match.

.NOTES
    Untested in PS 5.1
    Tested in PS 7.4.3
    Added test folder as example
.LINK
    https://github.com/FabioTavernini/FilesortPS
#>

[CmdletBinding()]
param (
    [Parameter()]
    [switch]$NoDialogue
)

#region Adding Types and defining Vars
Add-Type -AssemblyName System.Windows.Forms
#endregion

#region Functions
function Compare-FileHashes {
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$FilePaths
    )

    # Create a hashtable to store file hashes and corresponding file paths
    $hashTable = @{}

    foreach ($filePath in $FilePaths) {
        if (Test-Path $filePath) {
            # Compute the file hash
            $hash = Get-FileHash -Path $filePath -Algorithm SHA256

            # Store the file path under its hash in the hashtable
            if ($hashTable.ContainsKey($hash.Hash)) {
                $hashTable[$hash.Hash] += $filePath
            }
            else {
                $hashTable[$hash.Hash] = @($filePath)
            }
        }
        else {
            Write-Host "File not found: $filePath" -ForegroundColor Red
        }
    }

    # Return only the entries where more than one file path has the same hash
    $matchingFiles = @()
    foreach ($key in $hashTable.Keys) {
        if ($hashTable[$key].Count -gt 1) {
            $matchingFiles += [PSCustomObject]@{
                Hash  = $key
                Files = $hashTable[$key]
            }
        }
    }
    return $matchingFiles
}

#endregion

#region script execution

if ($NoDialogue -eq $false) {
    $FileBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{ InitialDirectory = ".\" }
    $Null = $FileBrowser.ShowDialog()

    $selectedpath = $FileBrowser.SelectedPath

}
else {
    $selectedpath = Read-Host -Prompt "Folder to check for duplicates"
}

$childelements = Get-ChildItem -Path $selectedpath -Recurse -Force | Select-Object LastWriteTime, Length, Name, FullName

$multiples = $childelements | Group-Object Name | Where-Object { $_.Count -gt 1 }

foreach ($multiple in $multiples) {

    compare-Filehashes -FilePaths $multiple.Group.FullName

}

#endregion