#Create a new file with Timestamp
New-Item -Path 'C:\Program Files\PowerShell' -Name "azure_batch_v_1.txt" -ItemType "File" -force
# Log in with user account using Az PowerShell
Login-AzAccount  -Subscription "e4462307-50e9-4297-ad8b-609e0b2f981a" -Tenant "7e572efb-19a0-444a-8425-45b37c50ef49" 

$accountName = "ftrenvstg"
$poolId = "ftrenvstgpnd"
$jobId = "devops"
$apiVersion = "2023-11-01.18.0"
$apiRegion= "eastus"

# Get the access token using Azure CLI
#$accessToken = ( Get-AzAccessToken).Token | ConvertTo-Json 
$accessToken = (Get-AzAccessToken -ResourceUrl https://batch.core.windows.pooooo).Token 

 
# New task json
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
 ‘2’ {
  cls




$New_scheduleID = Read-Host -Prompt "Enter your Schedule TaskId"
$ShdtaskId = Read-Host -Prompt "Enter your TaskId"
$shtaskcommand = Read-Host -Prompt 'Enter your task command with this format: cmd /c "your command prompt" '
$shtasktime = Read-Host -Prompt 'Enter your Task command with this format MM/DD/YYYYThh:mm exmple 2024-03-14T11:00:00.000Z'
# Define the API endpoint for adding schedule
$schedule_uri = "https://$accountName.$apiRegion.batch.azure.com/jobschedules?api-version=2023-11-01.18.0"  

  #new schedule task json
  $schedulejson= @"
{
    "id": "$New_scheduleID",
    
    "schedule": {
        "doNotRunUntil": $shtasktime,
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
            "id": "$ShdtaskId",
            "commandLine": '$shtaskcommand',
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

    try {
                                                
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
    Write-Host $schedulejson
                
} ‘1’ {
    cls
    # New task json
            
                     
        $NewtaskId= Read-Host -Prompt "Enter your TaskId"
        $NewTskcommand= Read-Host -Prompt 'Enter your task command with this format: cmd /c "your command prompt" '
        # Define the API endpoint for adding tasks #account.region.batch.azure.com/jobs?api-version=2023-11-01.18.0

        $Task_uri = "https://$accountName.$apiRegion.batch.azure.com/jobs/$jobId/tasks?api-version=$apiVersion" 

$taskJson= @"
{
    "id": "$NewtaskId",
    "commandLine": '$NewTskcommand',
  
    },
    "userIdentity": {
    "autoUser": {
        "scope": "task",
        "elevationLevel": "admin"
    }
    }
}
"@
                   
try {
                     
                     
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
    
    Write-Host $taskJson
    
                
}  '3' { 
        cls
     $schedule_uri = "https://$accountName.$apiRegion.batch.azure.com/jobschedules?api-version=2023-11-01.18.0"  
                   
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
#Modify schedule task json
                    $schedulejson= @"
        {
            "id": "$scheduleID",
    
            "schedule": {
                "doNotRunUntil": $time,
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
$scheduleID= Read-Host -Prompt "Enter your Schedule TaskId you want to modify"
$Put_schedule_uri = "https://$accountName.$apiRegion.batch.azure.com/jobschedules/$($scheduleID)?api-version=2023-11-01.18.0"

        $leaveOldCommand = Read-Host "Do you want to leave the old TASK command? (Y/N)"

        # If the user wants to leave the old variable, do nothing
        if ($leaveOldCommand -eq "Y") {
            Write-Host "The old task command variable will be kept."
        }

        # Otherwise, prompt the user for a new variable value
        else {
            $command = Read-Host 'Enter your Task command with this format cmd /c "command"'

            Write-Host "The taskcommand has been updated."
        }
                        
                        
        $leaveOldDate = Read-Host "Do you want to leave the old TASK time schedule? (Y/N)"

        # If the user wants to leave the old variable, do nothing
        if ($leaveOldDate -eq "Y") {
            Write-Host "The old task date variable will be kept."
        }

        # Otherwise, prompt the user for a new variable value
        else {
            $time = Read-Host 'Enter your Task command with this format MM/DD/YYYYThh:mm exmple 2024-03-14T11:00:00.000Z or 2024-03-14T21:00:00.000Z ' 

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




