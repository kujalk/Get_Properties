<#
Purpose - To find the size of folders and their last modified time
Developer - Janarthanan
Date - 1/3/2019
#>

<#
Parameters required -
1. Parent Directory
2. CSV file name with the path
#>


$location=Read-Host "Provide the folder location [Parent Directory]"

$file = Read-Host "Provide a location to store the CSV file <<C:\Citrix_Test\Testing.csv>> "

Add-Content -Path $file  -Value '"Folder Name","Last Modification Time","Last Accessed Time","Total Size in Mb"'

$users_folders=Get-ChildItem -Path $location | Select Name,LastWriteTime,LastAccessTime

$folders_Filtered=$users_folders.Name

$count_last=$users_folders.Count
$count=0

foreach ($a in $folders_Filtered)
{
try{
$size_folder=Get-ChildItem -Recurse $location\$a -ErrorAction Stop | Measure-Object -Property Length -Sum -ErrorAction Stop | select Sum -ExpandProperty Sum 
$lw=$users_folders[$count].LastWriteTime
$at=$users_folders[$count].LastAccessTime
$capacity=[math]::round($size_folder/1Mb,3)
"{0},{1},{2},{3}" -f $a,$lw,$at,$capacity| add-content -path $file
}
catch{
$lw=$users_folders[$count].LastWriteTime
$at=$users_folders[$count].LastAccessTime
$capacity="Access Denied -> Error"
"{0},{1},{2},{3}" -f $a,$lw,$at,$capacity| add-content -path $file
}

$count++
}


"Everything is done"