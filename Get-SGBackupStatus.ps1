Get-StorageGroup | foreach {
      $SG = $_
      $LogPath = $SG.LogFolderPath
      $oldestlog = get-childitem $LogPath -filter *.log | sort -property lastwritetime | select -first 1
      $FirstLogName = $SG.LogFilePrefix +"00000001.log"
      $NoOfLogs = (get-childitem $LogPath -filter *.log).count


      $Output =  [Environment]::NewLine + "SG Name:" + $SG.Name + [Environment]::NewLine + " SG Created: " + $SG.whenCreated 
      $Output = $Output + [Environment]::NewLine + " Oldest Log File: " + $OldestLog.Name + [Environment]::NewLine + " Timestamp: " + $OldestLog.LastWriteTime
      If ($OldestLog.Name -eq $FirstLogName)
              {$Output = $Output + [Environment]::NewLine + " First transaction log " + $FirstLogName + " still exists for Storage Group: " + $SG.Name
               Write-Host " First transaction log " $FirstLogName " still exists for Storage Group: " $SG.Name -ForegroundColor white -BackgroundColor DarkCyan
               Write-Host  " SG " $SG.Name " never backed up!" -ForegroundColor white -BackgroundColor DarkCyan}
     
      
      $output= $output + [Environment]::NewLine  + " Log FolderPath: " + $LogPath  + [Environment]::NewLine + " Log Prefix: " + $SG.LogFilePrefix
      $Output = $Output + [Environment]::NewLine + " Total Log Files: " + $NoOfLogs
      

     $DBs= Get-MailboxDatabase -Status -StorageGroup $SG
     $DBs | foreach {$DB = $_;
                     $DatabaseNo = $DatabaseNo + 1
                     $BackupTaken = "No"
                     $output = $output + [Environment]::NewLine + " Database"+$DatabaseNo +": " + $DB.Name
                          
                             
                    If ($DB.LastFullBackup -ne $null)
                       {$Output = $output + " Last Full Backup: " + $DB.LastFullBackup; $BackupTaken = "Yes"}  
                     If ($DB.SnapshotLastFullBackup -ne $null)
                       {$Output = $output + " Snapshot(Full): " + $DB.SnapshotLastFullBackup}
                             
                     If ($DB.LastIncrementalBackup -ne $null)
                       {$Output = $output + " Last Incremental Backup: " + $DB.LastIncrementalBackup; $BackupTaken = "Yes"} 
                     If ($DB.SnapshotLastIncrementalBackup -ne $null)
                       {$Output = $output + " Snapshot(Incremental): " + $DB.SnapshotLastIncrementalBackup}
        
                           
                     If ($DB.LastDifferentialBackup -ne $null)
                       {$Output = $output + " Last Differential Backup: " + $DB.LastDifferentialBackup; $BackupTaken = "Yes"}      
                     If ($DB.SnapshotLastDifferentialBackup -ne $null)
                       {$Output = $output + " Snapshot:(Differential) " + $DB.SnapshotLastIncrementalBackup}       
                             
                     
                     If ($BackupTaken -ne "Yes")
                        {$Output = $Output + " | Backup Status: Not backed up!"}
                     $BackupTaken = $null
                     
                     
                       }
   $DatabaseNo = $null
   $output = $output + [Environment]::NewLine 
   write-host $Output
   $output=$null}