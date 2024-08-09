# FilesortPS

## SYNOPSIS
A script to check for duplicate files in multiple directories.

## DESCRIPTION
Select folder with FolderBrowserDialog, then get all elements inside the folder and check the file hashes.
If the hashes match, return the filenames that are a match.

## NOTES
Untested in PS 5.1
Tested in PS 7.4.3
Added test folder as example

## How to run
Download or clone the repo, find [./sort.ps1](./sort.ps1) and execute using Powershell.
If the Filedialogue is not shown in foreground, check all opened windows with  `alt + tab`.