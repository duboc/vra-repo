function handler($context, $payload) {
  # ==================================== Constants ===============================================

$DISK_BINARY_TAG_VALUE = "Binary"
$DISK_DATA_TAG_VALUE = "Data"
$DISK_REDOLOG_TAG_VALUE = "Log"
$DISK_ARCHIVE_TAG_VALUE = "Archive"
$DISK_MOUNTPOINT_KEY = "mountPoint"

$MSSQL_INSTALL_CONFIG_FILE = "$PWD\MSSQLSetup.ini"
$SQL_SYSADMIN_ACCOUNT_SYSTEM = "NT AUTHORITY\SYSTEM"


#The property name list of supported database parameters
$DB_PARAM_PROPERTY_NAMES = @(
"RECOVERY_INTERVAL"            ,
"USER_CONNECTIONS"             ,
"FILL_FACTOR"                  ,
"MAX_WORKER_THREADS"           ,
"INDEX_CREATE_MEMORY"          ,
"PRIORITY_BOOST"               ,
"REMOTE_LOGIN_TIMEOUT"         ,
"CURSOR_THRESHOLD"             ,
"MIN_MEMORY_PER_QUERY"         ,
"MIN_SERVER_MEMORY"            ,
"MAX_SERVER_MEMORY"            ,
"BACKUP_COMPRESSION_DEFAULT"   ,
"OPTIMIZE_FOR_AD_HOC_WORKLOADS",
"REMOTE_QUERY_TIMEOUT"         ,
"LOCKS"
)

#The database parameter property to parameter name map
$DB_PARAM_PROPERTY_2_PARAM_NAME_MAP = @{
"RECOVERY_INTERVAL"             = "recovery interval (min)"      ;
"USER_CONNECTIONS"              = "user connections"             ;
"FILL_FACTOR"                   = "fill factor (%)"              ;
"MAX_WORKER_THREADS"            = "max worker threads"           ;
"INDEX_CREATE_MEMORY"           = "index create memory (KB)"     ;
"PRIORITY_BOOST"                = "priority boost"               ;
"REMOTE_LOGIN_TIMEOUT"          = "remote login timeout (s)"     ;
"CURSOR_THRESHOLD"              = "cursor threshold"             ;
"MIN_MEMORY_PER_QUERY"          = "min memory per query (KB)"    ;
"MIN_SERVER_MEMORY"             = "min server memory (MB)"       ;
"MAX_SERVER_MEMORY"             = "max server memory (MB)"       ;
"BACKUP_COMPRESSION_DEFAULT"    = "backup compression default"   ;
"OPTIMIZE_FOR_AD_HOC_WORKLOADS" = "optimize for ad hoc workloads";
"REMOTE_QUERY_TIMEOUT"          = "remote query timeout (s)"     ;
"LOCKS"                         = "locks"
}

#The database parameter property to parameter value range map
$DB_PARAM_PROPERTY_2_PARAM_VALUE_RANGE_MAP = @{
"RECOVERY_INTERVAL"             = (0, 32767, 0)               ;
"USER_CONNECTIONS"              = (0, 32767, 0)               ;
"FILL_FACTOR"                   = (0, 100, 0)                 ;
"MAX_WORKER_THREADS"            = (128, 32767, 0)             ;
"INDEX_CREATE_MEMORY"           = (704, 2147483647, 0)        ;
"PRIORITY_BOOST"                = (0, 1, 0)                   ;
"REMOTE_LOGIN_TIMEOUT"          = (0, 2147483647, 10)         ;
"CURSOR_THRESHOLD"              = (-1, 2147483647, -1)        ;
"MIN_MEMORY_PER_QUERY"          = (512, 2147483647, 1024)     ;
"MIN_SERVER_MEMORY"             = (0, 2147483647, 0)          ;
"MAX_SERVER_MEMORY"             = (16, 2147483647, 2147483647);
"BACKUP_COMPRESSION_DEFAULT"    = (0, 1, 0)                   ;
"OPTIMIZE_FOR_AD_HOC_WORKLOADS" = (0, 1, 0)                   ;
"REMOTE_QUERY_TIMEOUT"          = (0, 2147483647, 600)        ;
"LOCKS"                         = (5000, 2147483647, 0)
}


# ==================================== Functions ===============================================

function appdGetDiskAttributeByTag ($diskLayoutInfo, $tagName, $attributeName) {
    $attributeValues = @()
    if (($diskLayoutInfo -ne $null) -And ($diskLayoutInfo -ne "")) {
        $disks = getValueFromJson $diskLayoutInfo "disks"
        foreach ($disk in $disks) {
            $metaTags = getValueFromJson $disk "metaTags"
            foreach ($metaTag in $metaTags) {
                if ($tagName.equals($metaTag)) {
                    $attributeValue = getValueFromJson $disk $attributeName
                    $attributeValues += $attributeValue
                }
            }
        }
    }
    return ,$attributeValues
}

function appdGetDiskAttributeByName ($diskLayoutInfo, $diskName, $attributeName) {
    $attributeValue = $null
    if (($diskLayoutInfo -ne $null) -And ($diskLayoutInfo -ne "")) {
        $disks = getValueFromJson $diskLayoutInfo "disks"
        foreach ($disk in $disks) {
            $idiskname = getValueFromJson $disk "name"
            if ($diskName.equals($idiskname)) {
                $attributeValue = getValueFromJson $disk $attributeName
                break
            }
        }
    }
    return $attributeValue
}

function getDiskMountPointWithDefault ($diskMountPoints, $defaultMountPoint) {
    $diskMountPoint = $null
    if ($diskMountPoints -ne $null -And $diskMountPoints.Count -gt 0) {
        if ($diskMountPoints[0] | %{Test-Path "$($_)" -pathType Container}) {
            $diskMountPoint = $diskMountPoints[0]
        }
    }
    if ($diskMountPoint -eq $null) {
        $diskMountPoint = $defaultMountPoint
    }
    return $diskMountPoint
}


function createMSSQLConfigFile ($MSSQL_INSTALL_CONFIG_FILE) {
    New-Item -ItemType file $MSSQL_INSTALL_CONFIG_FILE
    echo ';SQL Server 2016 Standard Edition Configuration File
[OPTIONS]
; Specifies a Setup work flow, like INSTALL, UNINSTALL, or UPGRADE. This is a required parameter.
ACTION="Install"
; Detailed help for command line argument ENU has not been defined yet.
ENU="True"
; Setup will not display any user interface.
QUIET="True"
; Setup will display progress only, without any user interaction.
QUIETSIMPLE="False"
IACCEPTSQLSERVERLICENSETERMS="True"
; Specify whether SQL Server Setup should discover and include product updates. The valid values are True and False or 1 and 0. By default SQL Server Setup will include updates that are found.
UpdateEnabled="False"
; Specifies features to install, uninstall, or upgrade. The list of top-level features include SQL, AS, RS, IS, MDS, and Tools. The SQL feature will install the Database Engine, Replication, Full-Text, and Data Quality Services (DQS) server. The Tools feature will install Management Tools, Books online components, SQL Server Data Tools, and other shared components.
FEATURES=SQL,TOOLS
; Specify the location where SQL Server Setup will obtain product updates. The valid values are "MU" to search Microsoft Update, a valid folder path, a relative path such as .\MyUpdates or a UNC share. By default SQL Server Setup will search Microsoft Update or a Windows Update service through the Window Server Update Services.
UpdateSource="MU"
; Displays the command line parameters usage
HELP="False"
; Specifies that the detailed Setup log should be piped to the console.
INDICATEPROGRESS="False"
; Specifies that Setup should install into WOW64. This command line argument is not supported on an IA64 or a 32-bit system.
X86="False"
; Specify the root installation directory for shared components.  This directory remains unchanged after shared components are already installed.
INSTALLSHAREDDIR="#BINARYDISKMOUNTPOINT#\Program Files\Microsoft SQL Server"
; Specify the root installation directory for the WOW64 shared components.  This directory remains unchanged after WOW64 shared components are already installed.
INSTALLSHAREDWOWDIR="#BINARYDISKMOUNTPOINT#\Program Files (x86)\Microsoft SQL Server"
; Specify a default or named instance. MSSQLSERVER is the default instance for non-Express editions and SQLExpress for Express editions. This parameter is required when installing the SQL Server Database Engine (SQL), Analysis Services (AS), or Reporting Services (RS).
INSTANCENAME="#INSTANCENAME#"
; Specify the Instance ID for the SQL Server features you have specified. SQL Server directory structure, registry structure, and service names will incorporate the instance ID of the SQL Server instance.
INSTANCEID="#INSTANCENAME#"
; Specify that SQL Server feature usage data can be collected and sent to Microsoft. Specify 1 or True to enable and 0 or False to disable this feature.
SQMREPORTING="False"
; Specify if errors can be reported to Microsoft to improve future SQL Server releases. Specify 1 or True to enable and 0 or False to disable this feature.
ERRORREPORTING="False"
; Specify the installation directory.
INSTANCEDIR="#BINARYDISKMOUNTPOINT#\Program Files\Microsoft SQL Server"
; Agent account name
AGTSVCACCOUNT="NT AUTHORITY\SYSTEM"
; Auto-start service after installation.
AGTSVCSTARTUPTYPE="Manual"
; CM brick TCP communication port
COMMFABRICPORT="0"
; How matrix will use private networks
COMMFABRICNETWORKLEVEL="0"
; How inter brick communication will be protected
COMMFABRICENCRYPTION="0"
; TCP port used by the CM brick
MATRIXCMBRICKCOMMPORT="0"
; Startup type for the SQL Server service.
SQLSVCSTARTUPTYPE="Automatic"
; Level to enable FILESTREAM feature at (0, 1, 2 or 3).
FILESTREAMLEVEL="0"
; Specifies a Windows collation or an SQL collation to use for the Database Engine.
SQLCOLLATION="SQL_Latin1_General_CP1_CI_AS"
; Account for SQL Server service: Domain\User or system account.
SQLSVCACCOUNT="NT AUTHORITY\SYSTEM"
; The Database Engine root data directory.
INSTALLSQLDATADIR="#BINARYDISKMOUNTPOINT#\Program Files\Microsoft SQL Server"
; Default directory for the Database Engine backup files.
SQLBACKUPDIR="#ARCHIVEDISKMOUNTPOINT#\Program Files\Microsoft SQL Server\MSSQL11.#INSTANCENAME#\MSSQL\Backup"
; Default directory for the Database Engine user databases.
SQLUSERDBDIR="#DATADISKMOUNTPOINT#\Program Files\Microsoft SQL Server\MSSQL11.#INSTANCENAME#\MSSQL\Data"
; Default directory for the Database Engine user database logs.
SQLUSERDBLOGDIR="#REDOLOGDISKMOUNTPOINT#\Program Files\Microsoft SQL Server\MSSQL11.#INSTANCENAME#\MSSQL\Data"
; Directory for Database Engine TempDB files.
SQLTEMPDBDIR="#DATADISKMOUNTPOINT#\Program Files\Microsoft SQL Server\MSSQL11.#INSTANCENAME#\MSSQL\Data"
; Directory for the Database Engine TempDB log files.
SQLTEMPDBLOGDIR="#REDOLOGDISKMOUNTPOINT#\Program Files\Microsoft SQL Server\MSSQL11.#INSTANCENAME#\MSSQL\Data"
; Windows account(s) to provision as SQL Server system administrators.
SQLSYSADMINACCOUNTS=#SQLSYSADMINACCOUNTS# "NT AUTHORITY\SYSTEM"
; Specify sa Password
SAPWD="#SAPASSWORD#"
; Specify the Authentication Security Mode
SECURITYMODE=sql
; Specify 0 to disable or 1 to enable the TCP/IP protocol.
TCPENABLED="1"
; Specify 0 to disable or 1 to enable the Named Pipes protocol.
NPENABLED="0"
; Startup type for Browser Service.
BROWSERSVCSTARTUPTYPE="Automatic"
; Add description of input argument FTSVCACCOUNT
FTSVCACCOUNT="NT Service\MSSQLFDLauncher"
' | out-file -filepath $MSSQL_INSTALL_CONFIG_FILE
}

function updateInstallConfigSettings ($ConfigurationFile, $oldPara, $newPara) {
    (get-content $ConfigurationFile) | foreach-object {$_ -replace "$oldPara", "$newPara"} | set-content $ConfigurationFile
}

function validateDbParamValue ($paramName, $paramValue, [int[]]$valueRange) {
    if ($paramValue -ne $null -And $paramValue -ne "") {
        $value = [int]$paramValue
        $minValue = $valueRange[0]
        $maxValue = $valueRange[1]
        $defaultValue = $valueRange[2]
        if ((($value -ge $minValue) -And ($value -le $maxValue)) -Or ($value -eq $defaultValue)) {
            echo "$paramName will be applied to valid value $value."
        } else {
            echo "$paramName cannot be applied with invalid value $value. A valid value should be between $minValue ~ $maxValue, or equal to the default value $defaultValue."
            Exit 1
        }
    }
}


# ==================================== Script Execution ========================================

#Database parameters validation
foreach ($propertyName in $DB_PARAM_PROPERTY_NAMES) {
    $paramName = $DB_PARAM_PROPERTY_2_PARAM_NAME_MAP.Get_Item($propertyName)
    $paramValue = (Get-Variable $propertyName).Value
    $valueRange = $DB_PARAM_PROPERTY_2_PARAM_VALUE_RANGE_MAP.Get_Item($propertyName)
    validateDbParamValue $paramName $paramValue $valueRange
}

#Create SQL Server 2016 Standard Edition Configuration File
createMSSQLConfigFile $MSSQL_INSTALL_CONFIG_FILE

#Parse disk_layout_info
$diskLayoutInfo = $DISK_LAYOUT_INFO
echo "disk_layout_info is: $diskLayoutInfo"

#Extract disk mount point list from disk_layout_info by tag
$binaryDiskMountPoints  = appdGetDiskAttributeByTag $diskLayoutInfo $DISK_BINARY_TAG_VALUE $DISK_MOUNTPOINT_KEY
$dataDiskMountPoints    = appdGetDiskAttributeByTag $diskLayoutInfo $DISK_DATA_TAG_VALUE $DISK_MOUNTPOINT_KEY
$redologDiskMountPoints = appdGetDiskAttributeByTag $diskLayoutInfo $DISK_REDOLOG_TAG_VALUE $DISK_MOUNTPOINT_KEY
$archiveDiskMountPoints = appdGetDiskAttributeByTag $diskLayoutInfo $DISK_ARCHIVE_TAG_VALUE $DISK_MOUNTPOINT_KEY

#Get binary, data, redolog, archive disk mount point
$binaryDiskMountPoint  = getDiskMountPointWithDefault $binaryDiskMountPoints  "C:"
$dataDiskMountPoint    = getDiskMountPointWithDefault $dataDiskMountPoints    $binaryDiskMountPoint
$redologDiskMountPoint = getDiskMountPointWithDefault $redologDiskMountPoints $binaryDiskMountPoint
$archiveDiskMountPoint = getDiskMountPointWithDefault $archiveDiskMountPoints $binaryDiskMountPoint

#Parse the sysadmin accounts from SQL_SYSADMIN_ACCOUNTS property
$sqlSysadminAccounts = ""
$SQL_SYSADMIN_ACCOUNTS.Split(",") | ForEach {
    $account = $_.Trim()
    if ($account.ToUpper() -ne $SQL_SYSADMIN_ACCOUNT_SYSTEM) {
        $sqlSysadminAccounts += " `"$account`""
    }
}
$sqlSysadminAccounts = $sqlSysadminAccounts.Trim()
if ([string]::IsNullOrEmpty($SQL_SYSADMIN_ACCOUNTS.Trim()) -Or [string]::IsNullOrEmpty($sqlSysadminAccounts)) {
    echo "Cannot retrieve SQL Server sysadmin accounts from SQL_SYSADMIN_ACCOUNTS property."
    Exit 1
}

#Update the installation parameters
updateInstallConfigSettings $MSSQL_INSTALL_CONFIG_FILE "#INSTANCENAME#"          $INSTANCE_NAME
updateInstallConfigSettings $MSSQL_INSTALL_CONFIG_FILE "#SAPASSWORD#"            $SA_PWD
updateInstallConfigSettings $MSSQL_INSTALL_CONFIG_FILE "#SQLSYSADMINACCOUNTS#"   $sqlSysadminAccounts
updateInstallConfigSettings $MSSQL_INSTALL_CONFIG_FILE "#DATADISKMOUNTPOINT#"    $dataDiskMountPoint
updateInstallConfigSettings $MSSQL_INSTALL_CONFIG_FILE "#REDOLOGDISKMOUNTPOINT#" $redologDiskMountPoint
updateInstallConfigSettings $MSSQL_INSTALL_CONFIG_FILE "#ARCHIVEDISKMOUNTPOINT#" $archiveDiskMountPoint
updateInstallConfigSettings $MSSQL_INSTALL_CONFIG_FILE "#BINARYDISKMOUNTPOINT#"  $binaryDiskMountPoint

#Install .NET framework
#Import-Module ServerManager
#Add-WindowsFeature -Name net-framework

#Access SQL Server package from shared directory
if ($MSSQL_SETUP_LOCATION_ACCESS_USER -eq "") {
    net.exe use Z: $MSSQL_SETUP_LOCATION
} else {
    net.exe use Z: $MSSQL_SETUP_LOCATION $MSSQL_SETUP_LOCATION_ACCESS_PASSWORD /user:$MSSQL_SETUP_LOCATION_ACCESS_USER
}

#Check the SQL Server 2016 Standard Edition installation files
if (!("Z:" | %{Test-Path "$($_)" -pathType Container})) {
    echo "Failed to add a new network location from $MSSQL_SETUP_LOCATION."
    Exit 1
}
if (!("Z:\setup.exe" | %{Test-Path "$($_)" -pathType Leaf})) {
    echo "Cannot find the setup.exe file of SQL Server 2016 Standard Edition."
    Exit 1
}

#Set output INSTALL_PATH property
$INSTALL_PATH="$binaryDiskMountPoint\Program Files\Microsoft SQL Server\MSSQL11.$INSTANCE_NAME\MSSQL"
echo "SQL Server 2102 Enterprise Edition installation path is set to $INSTALL_PATH."

#Install SQL Server 2016 Standard Edition
Z:\setup.exe /CONFIGURATIONFILE=$MSSQL_INSTALL_CONFIG_FILE
$exitCode = $LastExitCode
if ($exitCode -eq 0) {
    echo "SQL Server 2016 Standard Edition installation succeeded!"
    Exit
} elseif ($exitCode -eq 3010) {
    echo "SQL Server 2016 Standard Edition installation succeeded! But a restart is required!"
    echo "Restart your computer now ......"
    Exit
} else {
    echo "SQL Server 2016 Standard Edition installation failed!"
    Exit 1
}



