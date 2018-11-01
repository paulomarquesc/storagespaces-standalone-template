$rgName = 'halliburton-rg01'
$vmName = 'e32s-accell'
$location = 'East US' 
$storageType = 'Premium_LRS'
$dataDiskName = $vmName + '_datadisk'
$diskCt = 7
$diskSize = 2048
$dataDisks = @()

$diskConfig = New-AzureRmDiskConfig -SkuName $storageType -Location $location -CreateOption Empty -DiskSizeGB $diskSize

for ($i=1; $i -le $diskCt;$i++)
{
    $dataDisks += New-AzureRmDisk -DiskName "$dataDiskName-$i" -Disk $diskConfig -ResourceGroupName $rgName
}

$vm = Get-AzureRmVM -Name $vmName -ResourceGroupName $rgName 

$i=1
foreach($dataDisk in $dataDisks)
{
    $vm = Add-AzureRmVMDataDisk -VM $vm -Name $dataDisk.Name -CreateOption Attach -ManagedDiskId $dataDisk.Id -Lun $i
    $i++
}

Update-AzureRmVM -VM $vm -ResourceGroupName $rgName