$drive_type = (Get-PhysicalDisk | Select "MediaType").MediaType.Contains("SSD")

if($drive_type)
{
write-host "SSD `r`n"
} else {
write-host "HDD `r`n"
}
