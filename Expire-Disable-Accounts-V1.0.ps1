##This application is used to disable/expire accounts

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

Clear-Host

#This allows you to move users - Canonical Name Preferred
#Example: $MoveFolder = "OU=Disabled_Accounts,DC=,DC="
$MoveFolder = $null

#Main Form
$Form_Accounts = New-Object System.Windows.Forms.Form
    $Form_Accounts.text = "Expire/Disable Accounts"
    $Form_Accounts.size = New-Object System.Drawing.Size(500,480)
    $Form_Accounts.FormBorderStyle = "FixedDialog"
    $Form_Accounts.TopMost = $true
    $Form_Accounts.MaximizeBox = $false
    $Form_Accounts.MinimizeBox = $false
    $Form_Accounts.ControlBox = $true
    $Form_Accounts.StartPosition = "CenterScreen"
    $Form_Accounts.Font = "Segoa UI"

#Label for SamAccountName for TextBox
$label_SamAccountName = New-Object System.Windows.Forms.Label
    $label_SamAccountName.Location = New-Object System.Drawing.Size(8,16)
    $label_SamAccountName.Size = New-Object System.Drawing.Size(150,16)
    $label_SamAccountName.TextAlign = "TopLeft"
    $label_SamAccountName.Text = "Enter SamAccountName:"
    $Form_Accounts.Controls.Add($label_SamAccountName)

#TextBox for SamAccountName - Used to Search for User to Disable
$textbox_SamAccountName = New-Object System.Windows.Forms.TextBox
    $textbox_SamAccountName.Location = New-Object System.Drawing.Size(8,32)
    $textbox_SamAccountName.Size = New-Object System.Drawing.Size(180,16)
    $textbox_SamAccountName.Text = "SamAccountName"
    $Form_Accounts.Controls.Add($textbox_SamAccountName)

#Label for Date for TextBox
$label_Date = New-Object System.Windows.Forms.Label
    $label_Date.Location = New-Object System.Drawing.Size(8,64)
    $label_Date.Size = New-Object System.Drawing.Size(120,16)
    $label_Date.TextAlign = "TopLeft"
    $label_Date.Text = "Enter Date:"
    $Form_Accounts.Controls.Add($label_Date)
    
#TextBox for Date - Used to set Date
$textbox_Date = New-Object System.Windows.Forms.TextBox
    $textbox_Date.Location = New-Object System.Drawing.Size(8,80)
    $textbox_Date.Size = New-Object System.Drawing.Size(180,16)
    $textbox_Date.Text = Get-Date -Format "M/d/yy"
    $Form_Accounts.Controls.Add($textbox_Date)

#Label for Time for TextBox
$label_Time = New-Object System.Windows.Forms.Label
    $label_Time.Location = New-Object System.Drawing.Size(8,112)
    $label_Time.Size = New-Object System.Drawing.Size(120,16)
    $label_Time.TextAlign = "TopLeft"
    $label_Time.Text = "Enter Time:"
    $Form_Accounts.Controls.Add($label_Time)

#label_TimeFormat for Time Format for TextBox
$label_TimeFormat = New-Object System.Windows.Forms.Label
    $label_TimeFormat.Location = New-Object System.Drawing.Size(6,128)
    $label_TimeFormat.Size = New-Object System.Drawing.Size(150,16)
    $label_TimeFormat.TextAlign = "TopLeft"
    $label_TimeFormat.Text = "(HH:MM or HH:MM AM/PM)"
    $Form_Accounts.Controls.Add($label_TimeFormat)

#TextBox for Time - Used to Disable by Date
$textbox_Time = New-Object System.Windows.Forms.TextBox
    $textbox_Time.Location = New-Object System.Drawing.Size(8,144)
    $textbox_Time.Size = New-Object System.Drawing.Size(180,16)
    $textbox_Time.Text = "11:59 PM" 
    $Form_Accounts.Controls.Add($textbox_Time)

#WhatIf checkbox to validate correct users
$checkbox_WhatIf = New-Object System.Windows.Forms.CheckBox
    $checkbox_WhatIf.Location = New-Object System.Drawing.Size(8,192)
    $checkbox_WhatIf.Size = New-Object System.Drawing.Size(180,16)
    $checkbox_WhatIf.TextAlign = "TopLeft"
    $checkbox_WhatIf.Text = "WhatIf?"
    $checkbox_WhatIf.Checked = $true
    $Form_Accounts.Controls.Add($checkbox_WhatIf)

#Label for Listbox of Users
$label_Users = New-Object System.Windows.Forms.Label
    $label_Users.Location = New-Object System.Drawing.Size(220,16)
    $label_Users.Size = New-Object System.Drawing.Size(180,16)
    $label_Users.TextAlign = "TopLeft"
    $label_Users.Text = "Accounts Set To Expire:"
    $Form_Accounts.Controls.Add($label_Users)

#Get all expiring users - Default 30 Days out
$ExpiringUsers = Search-ADAccount -AccountExpiring -TimeSpan 30.00:00:00
#Listbox for all Expiring Users
$listbox_Users = New-Object System.Windows.Forms.ListBox
    $listbox_Users.Location = New-Object System.Drawing.Size(220,32)
    $listbox_Users.Size = New-Object System.Drawing.Size(220,180)
    #Add all Expired users to Listbox
    foreach($Users in $ExpiringUsers)
    {
        $listbox_Users.Items.Add($Users.SamAccountName + " " + $Users.AccountExpirationDate) # Causing indexes
        Clear-Host #Clearing Console from Items added
    }
    
    #Listen for Clicks
    $listbox_Users.Add_Click({
        #Search through list of expired users
        foreach($Users in $ExpiringUsers)
        {
            #Who was clicked
            if($listbox_Users.SelectedItem -eq $Users.SamAccountName + " " + $Users.AccountExpirationDate)
            {
                $textbox_SamAccountName.Text = $Users.SamAccountName
            }
        }
    })
    $Form_Accounts.Controls.Add($listbox_Users)

#Expire Radio Button
$radiobutton_Expire = New-Object System.Windows.Forms.RadioButton
    $radiobutton_Expire.Location = New-Object System.Drawing.Size(8,224)
    $radiobutton_Expire.Size = New-Object System.Drawing.Size(80,16)
    $radiobutton_Expire.Text = "Expire"
    $radiobutton_Expire.Checked = $true
    #Enable Expire Functions
    $radiobutton_Expire.Add_Click({ 
        $textbox_Time.Enabled = $true
        $textbox_Date.Enabled = $true
    })
    $Form_Accounts.Controls.Add($radiobutton_Expire)  

#Disable Radio Button
$radiobutton_Disable = New-Object System.Windows.Forms.RadioButton
    $radiobutton_Disable.Location = New-Object System.Drawing.Size(96,224)
    $radiobutton_Disable.Size = New-Object System.Drawing.Size(80,16)
    $radiobutton_Disable.Text = "Disable"
    #Enable Disable Functions
    $radiobutton_Disable.Add_Click({ 
        $textbox_Time.Enabled = $false
        $textbox_Date.Enabled = $false
        #Enable Ticket Request if Checked
        if($checkbutton_TicketRequest.Checked -eq $true)
        {
            $textbox_TicketNumber.Enabled = $true
        }
    })
    $Form_Accounts.Controls.Add($radiobutton_Disable)

#Expire/Disable button
$button_ExpireDisable = New-Object System.Windows.Forms.Button
    $button_ExpireDisable.Location = New-Object System.Drawing.Size(8,252)
    $button_ExpireDisable.Size = New-Object System.Drawing.Size(180,32)
    $button_ExpireDisable.TextAlign = "MiddleCenter"
    $button_ExpireDisable.Text = "Expire/Disable"
    #Expire or Disable a account
    $button_ExpireDisable.Add_Click({
        #Attempt to Find User
        try
        {
            #Get Values from text boxes
            $SamAccountName = Get-ADUser -identity $textbox_SamAccountName.Text
            $Date = $textbox_Date.Text
            $Time = $textbox_Time.Text
            $Date = $Date + " " + $Time
            $CurrentDate = Get-Date
            
            #Disable Radio Button Selected
            if($radiobutton_Disable.Checked -eq $true)
            {
                #Whatif is Checked
                if($checkbox_WhatIf.Checked -eq $true)
                {
                    #Clear Console
                    Clear-Host

                    #Display The data that would be changed
                    Write-Host "Disabled: WhatIF?"
                    Get-ADUser -Identity $SamAccountName -Properties AccountExpirationDate,DisplayName | Format-Table SamAccountName,DisplayName,AccountExpirationDate,Enabled | Out-Host
                }
                else
                {
                    #Clear Console
                    Clear-Host

                    #Display The data that would be changed
                    Set-ADUser -Identity $SamAccountName -Enabled 0

                    #Display Disabled Changes
                    Write-Host "The following account has been Disabled:" $SamAccountName.SamAccountName 

                    #Check if there is a new OU location for disabled users - Set by user
                    try
                    {
                        if($MoveFolder -ne $null)
                        {
                            Move-ADObject -Identity $SamAccountName -TargetPath $MoveFolder
                            Write-Host "Account:" $SamAccountName.SamAccountName "To:" $MoveFolder
                        }
                    }
                    #Could not find new OU location
                    catch
                    {
                        Write-Host "Could not Locate User"
                    }

                    Get-ADUser -Identity $SamAccountName -Properties AccountExpirationDate,DisplayName | Format-Table SamAccountName,DisplayName,AccountExpirationDate,Enabled | Out-Host
                }
            }

            #Expire Radio Button Selected
            if($radiobutton_Expire.Checked -eq $true)
            {
                #WhatIf is Checked - Do not Implement Changes
                if($checkbox_WhatIf.Checked -eq $true)
                {
                    #Clear Console
                    Clear-Host

                    #Display The data that would be changed
                    Write-Host "Expire: WhatIF?"
                    Get-ADUser -Identity $SamAccountName -Properties AccountExpirationDate,DisplayName | Format-Table SamAccountName,DisplayName,AccountExpirationDate,Enabled | Out-Host
                }

                #Cannot Implement Changes as expire date is less than current date
                elseif([datetime]$Date -lt $CurrentDate -and $checkbox_WhatIf.Checked -eq $false)
                {
                    Write-Host "Expire Date before Today - Error"
                }

                #WhatIf is not Checked - Implement Changes
                else
                {
                    
                    try
                    {
                        #Clear Console
                        #Clear-Host

                        #Clear ListBox
                        $listbox_Users.Items.Clear()

                        #Get all expiring users - Default 30 Days out
                        $ExpiringUsers = Search-ADAccount -AccountExpiring -TimeSpan 30.00:00:00

                        #Add all Expired users to Listbox
                        foreach($Users in $ExpiringUsers)
                        {
                            if($Users.SamAccountName -ne $SamAccountName.SamAccountName)
                            {
                                $listbox_Users.Items.Add($Users.SamAccountName + " " + $Users.AccountExpirationDate)
                            }
                            else
                            {
                                $listbox_Users.Items.Add($SamAccountName.SamAccountName + " " + $Date)
                            }
                        }
                        
                        #Expire Account
                        Set-ADAccountExpiration -identity $SamAccountName.SamAccountName -datetime $Date
                        
                        #Display Expire Changes
                        Write-Host "The following account has been set to Expire:" $SamAccountName.SamAccountName
                        Get-ADUser -Identity $SamAccountName -Properties AccountExpirationDate,DisplayName | Format-Table SamAccountName,DisplayName,AccountExpirationDate,Enabled | Out-Host
                    }
                    #Incorrect Date Format
                    catch
                    {
                        [System.Windows.MessageBox]::Show('Incorrect Date Format.', "Incorrect Date!")
                    }
                } 
            }
        }
        #User Cannot be Found
        catch
        {
            [System.Windows.MessageBox]::Show('Could not locate this user.', "No User Found!")
        }
    })
    $Form_Accounts.Controls.Add($button_ExpireDisable)

#Show Form
$Form_Accounts.Add_Shown({$Form_Accounts.Activate()})
[void] $Form_Accounts.ShowDialog()
