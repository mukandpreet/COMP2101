function get_computersystem {

    get-wmiobject -class win32_computersystem | format-list Description
}

function get_operatingsystem {

    get-wmiobject -class win32_operatingsystem | format-list Name,Version
}

function get_processor {

    get-wmiobject -class win32_processor | format-list Description,MaxClockSpeed,NumberOfCores,L1CacheSize,L2CacheSize,L3CacheSize
}

function get_ram {

    get-wmiobject -class win32_physicalmemory | format-table Manufacturer,Description,Capacity,BankLabel,DeviceLocator
    $total_ram_installed = get-wmiobject -class win32_physicalmemory | Select-Object Capacity
    $output = $total_ram_installed.Capacity / 1gb;
    write-output "Total RAM: $output GB"
}

function logical_disk {

    $diskdrives = Get-CIMInstance CIM_diskdrive

    foreach ($disk in $diskdrives) {
        $partitions = $disk | get-cimassociatedinstance -resultclassname CIM_diskpartition
        foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                        new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                                Location=$partition.deviceid
                                                                Drive=$logicaldisk.deviceid
                                                                "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                                }
            }
        }
    }
}

function get_network {

    get-ciminstance win32_networkadapterconfiguration | Where-object -Property IPEnabled -eq True | format-table Caption,InterfaceIndex,IPAddress,IPSubnet,DNSDomain,DNSHostname
}

function get_graphics {
    $obj = get-ciminstance win32_videocontroller | Select-Object -Property CurrentHorizontalResolution,CurrentVerticalResolution
    $output = $obj.CurrentHorizontalResolution.ToString()+"x"+$obj.CurrentVerticalResolution.ToString()
    write-output $output;
}

get_computersystem
get_operatingsystem
get_processor
get_ram
logical_disk
get_network
get_graphics