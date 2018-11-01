param
(
    [string]$StoragePoolName="StoragePool1",
    [string]$VirtualDiskName="VirtualDisk1",
    [string]$FolderName="data",
    [string]$SharedFolderName="share",
    [string]$FullAccess="Everyone"
)

$columns=(Get-StoragePool -IsPrimordial $true | Get-PhysicalDisk | Where-Object CanPool -eq $True).count

New-StoragePool –FriendlyName $StoragePoolName –StorageSubsystemFriendlyName "Windows Storage*" –PhysicalDisks (Get-PhysicalDisk –CanPool $True)

$disk = New-VirtualDisk –StoragePoolFriendlyName $StoragePoolName –FriendlyName $VirtualDiskName –ResiliencySettingName "Simple" –UseMaximumSize -NumberOfColumns $columns
$disk | Initialize-Disk –Passthru | New-Partition –AssignDriveLetter –UseMaximumSize | Format-Volume -OutVariable Volume

$path = "$($volume.DriveLetter):\$FolderName" 
New-Item -Path $path -ItemType Directory

New-SmbShare -Name $SharedFolderName -Path $path -FullAccess $FullAccess -ContinuouslyAvailable $false -CachingMode None

