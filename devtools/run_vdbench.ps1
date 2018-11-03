$blockSizes=@("4k","16k","512k","1m","2m","4m")

foreach ($bs in $blocksizes)
{
	$OutputFolder="output-$bs"
	.\vdbench -f .\config.txt -o $OutputFolder xfersize=$bs
}