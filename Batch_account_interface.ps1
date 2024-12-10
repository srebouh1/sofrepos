
# Log in with user account using Az PowerShell
Login-AzAccount  -Subscription "e4462307-50e9-4297-ad8b-609e0b2f981a" -Tenant "7e572efb-19a0-444a-8425-45b37c50ef49" 

$accountName = "aze1adfs"
$poolId = "aze1adfspn2"
$jobId = "new"
$apiVersion = "2023-11-01.18.0"
$apiRegion= "eastus"
$jobScheduleId = "schedule0001"
# Get the access token using Azure CLI
#$accessToken = ( Get-AzAccessToken).Token | ConvertTo-Json 
$accessToken = (Get-AzAccessToken -ResourceUrl https://batch.core.windows.net).Token 

 
# Define the API endpoint for adding tasks #account.region.batch.azure.com/jobs?api-version=2023-11-01.18.0

$Task_uri = "https://$accountName.$apiRegion.batch.azure.com/jobs/$jobId/tasks?api-version=$apiVersion" 
# Set the task properties
#$variableName = Read-Host

#$command= "cmd /c ipconfig"
#$taskId= "task0008" 
#$scheduleID= "schId"
$taskJson= @"
{
  "id": "$taskId",
  "commandLine": '$command',
  
  },
  "userIdentity": {
    "autoUser": {
      "scope": "task",
      "elevationLevel": "admin"
    }
  }
}
"@
# Define the API endpoint for adding schedule
$schedule_uri = "https://$accountName.$apiRegion.batch.azure.com/jobschedules?api-version=2023-11-01.18.0"

$schedulejson= @"
{
    "id": "$scheduleID",
    
    "schedule": {
        "doNotRunUntil": "2024-03-14T11:00:00.000Z",
        "doNotRunAfter": "2027-03-13T05:00:00.000Z",
        "startWindow": null,
        "recurrenceInterval": "PT24H"
    },
    "jobSpecification": {
        "poolInfo": {
            "poolId": "aze1adfspn2"
        },
        "constraints": {
            "maxWallClockTime": null,
            "maxTaskRetryCount": 0
        },
        "jobManagerTask": {
            "id": "$taskId",
            "commandLine": '$command',
            "constraints": {
                "maxWallClockTime": null,
                "retentionTime": "PT168H",
                "maxTaskRetryCount": 0
            },
            "requiredSlots": 1,
            "applicationPackageReferences": []
        }
    }
}
"@

Write-Host $schedulejson

Write-Host $taskJson

# Convert task properties to JSON
#$taskJson = $taskProperties | ConvertTo-Json
 
####################################################################################################



function Show-Menu
{
     param (
           [string]$Title = ‘My Menu’
     )
     cls
     Write-Host “================ $Title ================”
    
     Write-Host “Add_Task: Press ‘1’ ”
     Write-Host “Add_schedule: Press ‘2’ ”
     Write-Host “List_schedule_Jobs: Press ‘3’ ”
     Write-Host “Modify_schedule_Jobs: Press ‘4’”
     Write-Host “Q: Press ‘Q’ to quit.”
}

do
{
     Show-Menu
     $input = Read-Host “Please make a selection”
     switch ($input)
     {
           ‘1’ {
                cls
                try {
                        $scheduleID= Read-Host -Prompt "Enter your Schedule TaskId"
                        $taskId= Read-Host -Prompt "Enter your TaskId"
                        $command= Read-Host -Prompt 'Enter your task command with this format: cmd /c "your command prompt" '
                        
                        
                    # Invoke the POST request to add the task
                    $s_response = Invoke-WebRequest -Uri $schedule_uri -Method Post -Verbose -Headers @{
                        "Content-Type" = "application/json; odata=minimalmetadata"
                        "Authorization" = "Bearer $accessToken"
        
                    } -UseBasicParsing -Body $schedulejson
 
                    # Display the response
                    $s_response.Content
                }
                catch {
                    # Handle errors
                    Write-Host "Error: $($_.Exception.Message)"
                    }
    
                
            } ‘2’ {
                cls

                   
                try {
                     
                     $taskId= Read-Host -Prompt "Enter your TaskId"
                     $command= Read-Host -Prompt 'Enter your task command with this format: cmd /c "your command prompt" '

                    # Invoke the POST request to add the task
                    $t_response = Invoke-WebRequest -Uri $Task_uri -Method POST -Verbose -Headers @{
                        "Content-Type" = "application/json; odata=minimalmetadata"
                        "Authorization" = "Bearer $accessToken"
        
                    } -UseBasicParsing -Body $taskJson
 
                    # Display the response
                    $t_response.Content
                }
                catch {
                    # Handle errors
                    Write-Host "Error: $($_.Exception.Message)"
                    }
    


                
           }  '3' { 
                    cls
            
                     try {
                    # Invoke the GET request to update the task schedule
                    $s_response = Invoke-WebRequest -Uri $schedule_uri -Method GET -Verbose -Headers @{
                        "Content-Type" = "application/json; odata=minimalmetadata"
                        "Authorization" = "Bearer $accessToken"
        
                    }
 
                    # Display the response
                    $x=$s_response.Content | ConvertFrom-Json 
                    $x.value | Format-Table -Property Id
                }
                catch {
                    # Handle errors
                    Write-Host "Error: $($_.Exception.Message)"
                    }
                 }

              '4' {
              cls
              $scheduleID= Read-Host -Prompt "Enter your Schedule TaskId you want to modify"
               $Put_schedule_uri = "https://$accountName.$apiRegion.batch.azure.com/jobschedules/$($scheduleID)?api-version=2023-11-01.18.0"

                        $leaveOldVariable = Read-Host "Do you want to leave the old TASK command? (Y/N)"

                        # If the user wants to leave the old variable, do nothing
                        if ($leaveOldVariable -eq "Y") {
                            Write-Host "The old task command variable will be kept."
                        }

                        # Otherwise, prompt the user for a new variable value
                        else {
                            $command = Read-Host 'Enter your Task command with this format cmd /c "command" '

                            Write-Host "The taskcommand has been updated."
                        }
                        
                        
                       

             
              try {

                    # Invoke the POST request to add the task
                    $s_response = Invoke-WebRequest -Uri $Put_schedule_uri -Method PUT -Verbose -Headers @{
                        "Content-Type" = "application/json; odata=minimalmetadata"
                        "Authorization" = "Bearer $accessToken"  
    
                    } -UseBasicParsing -Body $schedulejson
 
                    # Display the response
                    $t_response.Content
                }
                catch {
                    # Handle errors
                    Write-Host "Error: $($_.Exception.Message)"
                    }
              
              }
           
           
           ‘q’ {
                return
           }
     }
     pause
}
until ($input -eq ‘q’)

