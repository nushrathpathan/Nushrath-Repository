asnp Citrix*

$adminfolder = (Get-BrokerApplication -MaxRecordCount 10000).AdminFolderName | sort | select -unique | Out-GridView -Title "Select Admin Folder Name" -OutputMode Single
$applist = Get-Brokerapplication -AdminFolderName $adminfolder
$originalDG = (Get-BrokerDesktopGroup -MaxRecordCount 10000).Name | sort | Out-GridView -Title "Select Original Delivery Group Name" -OutputMode Single
$newDG = (Get-BrokerDesktopGroup -MaxRecordCount 10000).Name | sort | Out-GridView -Title "Select New Delivery Group Name" -OutputMode Single

Write-Host "Migrating all applications in $adminfolder`nFrom $originalDG Delivery Group to $newDG Delivery Group" -ForegroundColor Green

foreach ($app in $applist.ApplicationName){
                Write-host "Migrating $app"
                Get-BrokerApplication -ApplicationName $app | Add-BrokerApplication -DesktopGroup $newDG
                Get-BrokerApplication -ApplicationName $app | Remove-BrokerApplication -DesktopGroup $originalDG
                #Get-BrokerApplication -ApplicationName $app | Set-BrokerApplication -ClientFolder "Europe\QA" #optional to show all applications inside QA folder and not in the same folder with production apps
 }