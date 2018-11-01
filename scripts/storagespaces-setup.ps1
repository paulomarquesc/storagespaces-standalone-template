param
(
    [string]$StoragePoolName="StoragePool1",
    [string]$VirtualDiskName="VirtualDisk1",
    [string]$FolderName="data",
    [string]$SharedFolderName="share",
    [string]$FullAccess="Everyone"
)

$Columns=(Get-StoragePool -IsPrimordial $true | Get-PhysicalDisk | Where-Object CanPool -eq $True).count

New-StoragePool -FriendlyName $StoragePoolName -StorageSubSystemFriendlyName "Windows Storage*" -PhysicalDisks (Get-PhysicalDisk -CanPool $True)

$Disk = New-VirtualDisk -StoragePoolFriendlyName $StoragePoolName -FriendlyName $VirtualDiskName -ResiliencySettingName "Simple" -UseMaximumSize -NumberOfColumns $Columns
$Disk | Initialize-Disk -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize | Format-Volume -OutVariable Volume

$Path = "$($Volume.DriveLetter):\$FolderName"
New-Item -Path $Path -ItemType Directory

New-SmbShare -Name $SharedFolderName -Path $path -FullAccess $FullAccess -ContinuouslyAvailable $false -CachingMode None

