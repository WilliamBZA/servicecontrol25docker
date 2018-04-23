Write-Host "Starting SQL Server..."
start-service MSSQLSERVER
Write-Host "SQL Server Started"

Write-Host "Deleting previous DB..."
rm c:\sqldb\servicecontrol.ldf
rm c:\sqldb\servicecontrol.mdf
Write-Host "Deleted"

Write-Host "Deleting previous Raven DB..."
Remove-Item c:\temp\db -Force -Recurse
Remove-Item c:\temp\logs -Force -Recurse
Write-Host "Deleted"

Write-Host "Copying DB..."
copy c:\sqldb\copyservicecontrol.ldf c:\sqldb\servicecontrol.ldf
copy c:\sqldb\copyservicecontrol.mdf c:\sqldb\servicecontrol.mdf
Write-Host "Deleted"

Write-Host "Attaching loadtest DB..."
SqlCMD -Q 'CREATE DATABASE [loadtest] ON (FILENAME = N''C:\sqldb\servicecontrol.mdf''), (FILENAME = N''C:\sqldb\servicecontrol.ldf'') FOR ATTACH;';
Write-Host "Loadtest DB Created"

Write-Host "Installing ServiceControl...";

Import-Module 'C:/Program Files (x86)/Particular Software/ServiceControl Management/ServiceControlMgmt.psd1';
New-ServiceControlInstance -Name ServiceControl -InstallPath c:/servicecontrol -DBPath c:/temp/db -LogPath c:/temp/logs -Port 33333 -ErrorQueue error -AuditQueue audit -ErrorLogQueue errorlog -AuditLogQueue auditlog -Transport SQLServer -ForwardAuditMessages:$false -ForwardErrorMessages:$false -ConnectionString 'Data Source=.; Database=LoadTest; User Id=sa; Password=asdf1234!;' -AuditRetentionPeriod 01:00:00 -HostName * -ErrorRetentionPeriod 10:00:00:00;

ipconfig

c:\Tracker.exe

powershell