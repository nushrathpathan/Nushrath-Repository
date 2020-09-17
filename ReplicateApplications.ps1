#ReplicateApplications in 7.x 
#Contact Nusarat Pathan, Roopa L, Bindumalini B for any doubts/queries in this script.
Add-PSSnapin Citrix.*
$SourceFolder=(Get-BrokerApplication -MaxRecordCount 10000).AdminFolderName|sort|select -Unique|Out-GridView -Title "Source Domain Folder" -OutputMode Single
$DestinationFolder=(Get-BrokerAdminFolder).FolderName|sort|select -Unique|Out-GridView -Title "Target Domain Folder" -OutputMode Single
$DG=(Get-BrokerDesktopGroup -MaxRecordCount 10000).Name|sort|select -Unique|Out-GridView -Title "Target DG" -OutputMode Single
$Apps=(Get-BrokerApplication -AdminFolderName $SourceFolder)
$keywords = Read-Host -Prompt 'Enter the Keyword'
$src_domain= Read-Host -Prompt 'Source Domain'
$tgt_domain=Read-Host -Prompt 'Target Domain'
$MaxInstUser=Read-Host -Prompt 'Set Max Instance per user (Default is 0)'
$ClientFolder=Read-Host -Prompt 'ClientFolder (Application Category)'
$desktop=Read-Host -Prompt 'Add shortcut to user desktop?Yes/No'

foreach($App in $Apps)
{
$appname=$app.ApplicationName
$browsername=$appname-replace $src_domain,$tgt_domain
if($Desktop -eq 'Yes')
{
New-BrokerApplication -ApplicationType HostedOnDesktop -CommandLineExecutable $app.CommandLineExecutable -AdminFolder $DestinationFolder -CommandLineArguments $app.CommandLineArguments -Enabled $app.Enabled -Name $browsername -UserFilterEnabled $app.UserFilterEnabled -WorkingDirectory $app.WorkingDirectory -PublishedName $browsername -DesktopGroup $DG -IconUid $app.IconUid -Description "KEYWORDS:$keywords" -BrowserName $browsername -MaxPerUserInstances $MaxInstUser -ClientFolder $ClientFolder -ShortcutAddedToDesktop 1
}else{
New-BrokerApplication -ApplicationType HostedOnDesktop -CommandLineExecutable $app.CommandLineExecutable -AdminFolder $DestinationFolder -CommandLineArguments $app.CommandLineArguments -Enabled $app.Enabled -Name $browsername -UserFilterEnabled $app.UserFilterEnabled -WorkingDirectory $app.WorkingDirectory -PublishedName $browsername -DesktopGroup $DG -IconUid $app.IconUid -Description "KEYWORDS:$keywords" -BrowserName $browsername -MaxPerUserInstances $MaxInstUser -ClientFolder $ClientFolder -ShortcutAddedToDesktop 0
}
$users=$app.AssociatedUserNames
$Limit=$DestinationFolder+"\"+$browsername 
foreach($user in $users){
Get-BrokerApplication -Name "$limit"|Add-BrokerUser "$user"
}
}