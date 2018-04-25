#TempAccess_v2.0


#Import of Active Directory Module
Import-Module ActiveDirectory


#enter username and password for authorization
$domaincred = get-credential -Message "Enter your MBH domain username and password for authentication"
$adminusername = $domaincred.username
$adminpassword = $domaincred.GetNetworkCredential().password

 # Get current domain using logged-on user's credentials
 $CurrentDomain = "LDAP://" + ([ADSI]"").distinguishedName
 $domain = New-Object System.DirectoryServices.DirectoryEntry($CurrentDomain,$adminusername,$adminpassword)
 

function Temp_Access_Add($UserName,$AccessGroup)
         {
             Add-ADPrincipalGroupMembership -Identity $UserName -MemberOf $AccessGroup -Credential $domaincred
         }

function Temp_Access_Remove($UserName, $AccessGroup)
         {
              Remove-ADPrincipalGroupMembership -Identity $UserName -MemberOf $AccessGroup -Credential $domaincred -Confirm:$false
         }

function Check_Membership($Username, $CheckGroup)
        {
              Get-ADGroupMember -Identity $checkgroup -Recursive | Select-Object samaccountname
              If ($checkgroup.samaccountname -contains $username.samaccountname) {
                          Start-sleep -s 2
                          Write-Host ' ' 
                          Write-Host 'Confirmed!' -ForegroundColor Green
                          Write-Host ' '
                          Write-Host "$username is a member of the group" -ForegroundColor Green
                          Write-host " "
                          Start-sleep -s 2
                     } Else {
                            Write-Host ' ' 
                            Write-Host "$username is NOT a member of the group" -ForegroundColor Red
                            Start-sleep -s 2
                    }
        }

function GroupTable($CheckGroup) 
    {
    Write-Host "List of Users in $CheckGroup Group:" -foregroundcolor cyan

    Get-ADGroupMember -Identity $checkgroup | Get-ADObject -Properties samaccountname,Name, Cn | Ft samaccountname,Name
    }



if ($domain.name -eq $null)
{
 write-host " " 
 write-host "---------------------------------------------------" -ForegroundColor Red
 write-host "Authentication failed - please verify your username and password." -ForegroundColor Red
 write-host "---------------------------------------------------" -ForegroundColor Red
 write-host " " 
 Exit #terminate the script.
}
else
{
 write-host " " 
 write-host "---------------------------------------------------" -ForegroundColor Green
 write-host "Successfully authenticated with domain $($domain.name)" -ForegroundColor Green
 write-host "---------------------------------------------------" -ForegroundColor Green
 write-host " " 
}


#welcome screen
Write-Host "--------------------------------------------------------------------------------------------------------" -ForegroundColor White
Write-Host "Welcome to                                                                                              " -ForegroundColor Magenta
Write-Host " ________                                   ______                                                      " -ForegroundColor Green
Write-Host "|        \                                 /      \                                                     " -ForegroundColor Green
Write-Host " \%%%%%%%%______   ______ ____    ______  |  %%%%%%\  _______   _______   ______    _______   _______   " -ForegroundColor Green
Write-Host "   | %%  /      \ |      \    \  /      \ | %%__| %% /       \ /       \ /      \  /       \ /       \  " -ForegroundColor Green
Write-Host "   | %% |  %%%%%%\| %%%%%%\%%%%\|  %%%%%%\| %%    %%|  %%%%%%%|  %%%%%%%|  %%%%%%\|  %%%%%%%|  %%%%%%%  " -ForegroundColor Green
Write-Host "   | %% | %%    %%| %% | %% | %%| %%  | %%| %%%%%%%%| %%      | %%      | %%    %% \%%    \  \%%    \   " -ForegroundColor Green
Write-Host "   | %% | %%%%%%%%| %% | %% | %%| %%__/ %%| %%  | %%| %%_____ | %%_____ | %%%%%%%% _\%%%%%%\ _\%%%%%%\  " -ForegroundColor Green
Write-Host "   | %%  \%%     \| %% | %% | %%| %%    %%| %%  | %% \%%     \ \%%     \ \%%     \|       %%|       %%  " -ForegroundColor Green
Write-Host "    \%%   \%%%%%%% \%%  \%%  \%%| %%%%%%%  \%%   \%%  \%%%%%%%  \%%%%%%%  \%%%%%%% \%%%%%%%  \%%%%%%%   " -ForegroundColor Green
Write-Host "                                | %%                                                                    " -ForegroundColor Green
Write-Host "                                | %%                                                                    " -ForegroundColor Green
Write-Host "                                 \%%                                                                    " -ForegroundColor Green
Write-Host " "
Write-Host " "
Write-Host "                                                                                          v2.0          " -ForegroundColor Yellow
Write-Host "--------------------------------------------------------------------------------------------------------" -ForegroundColor White
Write-Host " "
Write-Host " "



# Main_Menu for Add, Remove, Exit
Do {
    Write-Host "-------------------------------------" -ForegroundColor Yellow 
    Write-Host "-----------  Main Menu --------------"
    Write-host "-------------------------------------" -ForegroundColor Yellow 
    Write-Host "A - Add Member"
    Write-host "R - Remove Member"
    Write-host "C - Check user group membership"
    WRite-Host "X - Exit"
    Write-Host "-------------------------------------" -ForegroundColor Yellow 
    Write-Host " "

    $MainMenu = Read-Host "Enter A/R/C/X" 

    # Main_Menu Switch Statement between Add, Remove, Exit
    Switch ($MainMenu) {
        #Add Request
        'A' { 
                # Do-while Statement for Server_Menu Add
                Do {
                    $AddServer_Menu = 0
                    Write-Host " "
                    Write-Host '-------------------'
                    Write-Host '---Adding Access---' -ForegroundColor Green
                    Write-Host '-------------------'
                    Write-Host " "
                    $Username = Read-Host "Enter Username to give temporary server access"
                    Write-Host " "

                    #check that user exists in AD
                    $checkuser = $Username
                    $checkname = $(try {Get-ADUser $checkuser} catch {$null})

                        If ($checkname -ne $Null) {
                     
                            Write-Host " "
                            Write-Host "User $username exists in AD" -ForegroundColor Green
                            Write-Host " "
                            Start-Sleep -s 2
                            } 
                            Else {
                            Write-Host " "
                            Write-Host "User $username does not exist on the MBH Domain, please start again" -ForegroundColor Red
                            Write-Host " "
                            Start-Sleep -s 2
                            }

                       

                    #Do-while loop for the $AddServer_Menu (and to return to change username)
                    Do{

                        $AddServer_Menu = 0
                        #Server_Menu Table Display
				        Write-Host "-----------Server Table--------------" -ForegroundColor Yellow
                        Write-Host "      For User:  $UserName" -foregroundcolor Cyan
                        Write-Host " "
                        Write-Host "---#----Server-------#-----Server----"
                        Write-Host "  1  STLMOJ2EE01  |  2  STLMOJ2EE02" 
                        Write-Host "  3  STLMOJ2EE05  |  4  STLMOJ2EE06"
                        Write-Host "  5  STLMOJ2EE07  |  6  STLMOJ2EE08"
                        Write-Host "  7  STLMOJ2EE09  |  8  STLMOJ2EE11"
				        Write-Host "  9  STLMOJ2EE12  | 10  STLMOJ2EE14"
                        Write-Host " 11  STLMOJ2EE15  | 12  STLMOJ2EE16"
                        Write-Host " 13  STLMOJ2EE17  | 14  STLMOTDS01"
                        Write-Host " 15  STLMOTDS02   | 16  STLMRXREMR01"
                        Write-Host " 17  STLMOJ2EEQ01"
                        Write-Host " "
                        Write-Host '20 - back to Change username'
                        Write-host '21 - Back to main menu'
                        Write-Host "--------------------------------------"
                        Write-Host " "
                
                        #prompt for add user to Group
                        

                        $AddServer_Menu = Read-Host 'What is the group you want to add the user to?'

                            #Switch Statement for Server_Menu to Add 
                            Switch ($AddServer_Menu)
                            {
                                1 {Temp_Access_Add -AccessGroup "STLMOJ2EE01_Admin" -UserName $UserName
                                   
                                    $AddServer_Menu = 1
                                    Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                                2 {Temp_Access_Add -AccessGroup "STLMOJ2EE02_Admin" -UserName $UserName
                                    $AddServer_Menu = 2
                                    Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                                3 {Temp_Access_Add -AccessGroup "STLMOJ2EE05_Admin" -UserName $UserName
                                   $AddServer_Menu = 3
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                                4 {Temp_Access_Add -AccessGroup "STLMOJ2EE06_Admin" -UserName $UserName
                                   $AddServer_Menu = 4
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                                5 {Temp_Access_Add -AccessGroup "STLMOJ2EE07_Admin" -UserName $UserName
                                   $AddServer_Menu = 5
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                                6 {Temp_Access_Add -AccessGroup "STLMOJ2EE08_Admin" -UserName $UserName
                                   $AddServer_Menu = 6
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                                7 {Temp_Access_Add -AccessGroup "STLMOJ2EE09_Admin" -UserName $UserName
                                  $AddServer_Menu = 7
                                    Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                                8 {Temp_Access_Add -AccessGroup "STLMOJ2EE11_Admin" -UserName $UserName
                                   $AddServer_Menu = 8
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                                9 {Temp_Access_Add -AccessGroup "STLMOJ2EE12_Admin" -UserName $UserName
                                   $AddServer_Menu = 9
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                               10 {Temp_Access_Add -AccessGroup "STLMOJ2EE14_Admin" -UserName $UserName
                                   $AddServer_Menu = 10
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                               11 {Temp_Access_Add -AccessGroup "STLMOJ2EE15_Admin" -UserName $UserName
                                  $AddServer_Menu = 11
                                  Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                               12 {Temp_Access_Add -AccessGroup "STLMOJ2EE16_Admin" -UserName $UserName
                                   $AddServer_Menu = 12
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                               13 {Temp_Access_Add -AccessGroup "STLMOJ2EE17_Admin" -UserName $UserName
                                  $AddServer_Menu = 13
                                  Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                               14 {Temp_Access_Add -AccessGroup "STLMOTDS01_Admin" -UserName $UserName
                                  $AddServer_Menu = 14
                                  Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                               15 {Temp_Access_Add -AccessGroup "STLMOTDS02_Admin" -UserName $UserName
                                  $AddServer_Menu = 15
                                  Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                               16 {Temp_Access_Add -AccessGroup "STLMRXERMR01" -UserName $UserName
                                  $AddServer_Menu = 16
                                  Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                               17 {Temp_Access_Add -AccessGroup "STLMOJ2EEQ01_Admin" -UserName $UserName
                                   $AddServer_Menu = 17
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                               
                               20 { Write-host ' '
                                    Write-host "returning to change username"}
                               21 { Write-Host ' '
                                    Write-host "returning to Main Menu..."}
                                # Default {Write-Warning 'Incorrect value entered. Please enter a single number or Q'}

                             } # End of Switch for Server_Menu for Add
                    
                      
                   
                    }Until ($AddServer_Menu -gt 19) # End of Do-while loop for Adding Access for $username

        
                }Until ($AddServer_Menu -gt 20) # End of Do-While loop for "Adding Access Menu"
         


          } #End of 'A' Switch for mainmenu



        'R' {
                Do{ 
                   $removemenu = 0
                    Write-Host " "
                    Write-Host '----------------------'
                    Write-host "--Remove Access Menu--" -foregroundcolor Magenta
                    Write-Host '----------------------'
                    Write-Host " "
                    $Username = Read-Host "Enter Username to give temporary server access"
                    Write-Host " "

                    #check that user exists in AD
                    $checkuser = $Username
                    $checkname = $(try {Get-ADUser $checkuser} catch {$null})

                        If ($checkname -ne $Null) {
                     
                            Write-Host " "
                            Write-Host "User $username exists in AD" -ForegroundColor Green
                            Write-Host " "
                            Start-Sleep -s 2
                            } 
                            Else {
                            Write-Host " "
                            Write-Host "User $username does not exist on the MBH Domain, please start again" -ForegroundColor Red
                            Write-Host " "
                            Start-Sleep -s 2
                            }

                       

                    #Do-while loop for the $AddServer_Menu (and to return to change username)
                    Do{

                        $removemenu = 0
                        #Server_Menu Table Display
				        Write-Host "-----------Server Table--------------" -ForegroundColor Yellow
                        Write-Host "      For User:  $UserName" -foregroundcolor Cyan
                        Write-Host " "
                        Write-Host "---#----Server-------#-----Server----"
                        Write-Host "  1  STLMOJ2EE01  |  2  STLMOJ2EE02" 
                        Write-Host "  3  STLMOJ2EE05  |  4  STLMOJ2EE06"
                        Write-Host "  5  STLMOJ2EE07  |  6  STLMOJ2EE08"
                        Write-Host "  7  STLMOJ2EE09  |  8  STLMOJ2EE11"
				        Write-Host "  9  STLMOJ2EE12  | 10  STLMOJ2EE14"
                        Write-Host " 11  STLMOJ2EE15  | 12  STLMOJ2EE16"
                        Write-Host " 13  STLMOJ2EE17  | 14  STLMOTDS01"
                        Write-Host " 15  STLMOTDS02   | 16  STLMRXREMR01"
                        Write-Host " 17  STLMOJ2EEQ01"
                        Write-Host " "
                        Write-Host '20 - back to Change username'
                        Write-host '21 - Back to main menu'
                        Write-Host "--------------------------------------"
                        Write-Host " "
                
                        #prompt for add user to Group

                        $removemenu = Read-Host 'What is the group you want to remove the user to?'

                            #Switch Statement for Server_Menu to Add 
                            Switch ($removemenu)
                            {
                                1 {Temp_Access_Remove -AccessGroup 'STLMOJ2EE01_Admin' -UserName $UserName
                                    $removemenu = 1
                                    Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}

                                2 {Temp_Access_Remove -AccessGroup 'STLMOJ2EE02_Admin' -UserName $UserName
                                    $removemenu = 2
                                    Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}

                                3 {Temp_Access_Remove -AccessGroup 'STLMOJ2EE05_Admin' -UserName $UserName
                                   $removemenu = 3
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}

                                4 {Temp_Access_Remove -AccessGroup 'STLMOJ2EE06_Admin' -UserName $UserName
                                   $removemenu = 4
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}

                                5 {Temp_Access_Remove -AccessGroup 'STLMOJ2EE07_Admin' -UserName $UserName
                                   $removemenu = 5
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}

                                6 {Temp_Access_Remove -AccessGroup 'STLMOJ2EE08_Admin' -UserName $UserName
                                   $removemenu = 6
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}

                                7 {Temp_Access_Remove -AccessGroup 'STLMOJ2EE09_Admin' -UserName $UserName
                                  $removemenu = 7
                                    Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}

                                8 {Temp_Access_Remove -AccessGroup 'STLMOJ2EE11_Admin' -UserName $UserName
                                   $removemenu = 8
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}

                                9 {Temp_Access_Remove -AccessGroup 'STLMOJ2EE12_Admin' -UserName $UserName
                                   $removemenu = 9
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}

                               10 {Temp_Access_Remove -AccessGroup 'STLMOJ2EE14_Admin' -UserName $UserName
                                   $removemenu = 10
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}

                               11 {Temp_Access_Remove -AccessGroup 'STLMOJ2EE15_Admin' -UserName $UserName
                                  $removemenu = 11
                                  Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}

                               12 {Temp_Access_Remove -AccessGroup 'STLMOJ2EE16_Admin' -UserName $UserName
                                   $removemenu = 12
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}

                               13 {Temp_Access_Remove -AccessGroup "STLMOTDS01_Admin" -UserName $UserName
                                  $removemenu = 13
                                  Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                               14 {Temp_Access_Remove -AccessGroup 'STLMOTDS02_Admin' -UserName $UserName
                                  $removemenu = 14
                                  Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}

                               15 {Temp_Access_Remove -AccessGroup "STLMOJ2EEQ01_Admin" -UserName $UserName
                                  $removemenu = 15
                                  Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}

                               16 {Temp_Access_Remove -AccessGroup "STLMRXERMR01_Admin" -UserName $UserName
                                  $removemenu = 16
                                  Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}

                               17 {Temp_Access_Remove -AccessGroup "STLMOJ2EE01_Admin" -UserName $UserName
                                   $removemenu = 17
                                   Start-sleep -s 2
                                    Write-host " "
                                    Write-host "function completed. Returning to Server Table" -ForegroundColor Green
                                    Write-host " "
                                    Start-sleep -s 2}
                               
                               20 { Write-host ' '
                                    Write-host "returning to change username"}
                               21 { Write-Host ' '
                                    Write-host "returning to Main Menu..."}
                   

                        } #End of switch - $removemenu

                    }Until ($removemenu -gt 19) # End of Do-while loop for Removing Access for $username

        
                }Until ($removemenu -gt 20) # End of Do-While loop for "Remove Access Menu"
        
         } #End of Switch option 'R' - Remove

        'C' {
                Do {
                    #$Check_Menu = 0
                    Write-Host " "
                    Write-Host '-------------------------------'
                    Write-Host '---Checking Group Membership---' -ForegroundColor Cyan
                    Write-Host '-------------------------------'
                    Write-Host " "
                    Write-host "PLEASE give Active Directory approx 3 minutes to replicate before validating group membership" -ForegroundColor Yellow


                    	Write-Host "-----------Server Table--------------" -ForegroundColor Yellow
                        Write-Host " "
                        Write-Host "---#----Server-------#-----Server----"
                        Write-Host "  1  STLMOJ2EE01  |  2  STLMOJ2EE02" 
                        Write-Host "  3  STLMOJ2EE05  |  4  STLMOJ2EE06"
                        Write-Host "  5  STLMOJ2EE07  |  6  STLMOJ2EE08"
                        Write-Host "  7  STLMOJ2EE09  |  8  STLMOJ2EE11"
				        Write-Host "  9  STLMOJ2EE12  | 10  STLMOJ2EE14"
                        Write-Host " 11  STLMOJ2EE15  | 12  STLMOJ2EE16"
                        Write-Host " 13  STLMOJ2EE17  | 14  STLMOTDS01"
                        Write-Host " 15  STLMOTDS02   | 16  STLMRXREMR01"
                        Write-Host " 17  STLMOJ2EEQ01"
                        Write-Host " "
                        Write-Host '20 - Back to main menu'
                        Write-Host "--------------------------------------"
                        Write-Host " "

                        Write-Host " "
                        $Check_Menu = Read-host "choose from the list of groups to check membership"
                        Write-Host " "

                        #Swtich for Check Menu
                        Switch ($Check_Menu)
                        {
                            1 {GroupTable -checkgroup STLMOJ2EE01_Admin
                             $Check_Menu = 1}
                            
                            2 {GroupTable -checkgroup STLMOJ2EE02_Admin
                             $Check_Menu = 2}
                            
                            3 {GroupTable -checkgroup STLMOJ2EE05_Admin
                             $Check_Menu = 3}
                            
                            4 {GroupTable -checkgroup STLMOJ2EE06_Admin
                             $Check_Menu = 4}
                            
                            5 {GroupTable -checkgroup STLMOJ2EE07_Admin
                             $Check_Menu = 5}
                            
                            6 {GroupTable -checkgroup STLMOJ2EE08_Admin
                             $Check_Menu = 6}
                            
                            7 {GroupTable -checkgroup STLMOJ2EE09_Admin
                             $Check_Menu = 7}
                            
                            8 {GroupTable -checkgroup STLMOJ2EE11_Admin
                             $Check_Menu = 8}
                            
                            9 {GroupTable -checkgroup STLMOJ2EE12_Admin
                             $Check_Menu = 9}
                            
                            10 {GroupTable -checkgroup STLMOJ2EE14_Admin
                             $Check_Menu = 10}
                            
                            11 {GroupTable -checkgroup STLMOJ2EE15_Admin
                             $Check_Menu = 11}
                           
                            12 {GroupTable -checkgroup STLMOJ2EE16_Admin
                             $Check_Menu = 12}
                           
                            13 {GroupTable -checkgroup STLMOJ2EE17_Admin
                             $Check_Menu = 13}
                          
                            14 {GroupTable -checkgroup STLMOTDS01_Admin
                             $Check_Menu = 14}
                         
                            15 {GroupTable -checkgroup STLMOTDS02_Admin
                             $Check_Menu = 15}
                         
                            16 {GroupTable -checkgroup STLMRXERMR01_Admin
                             $Check_Menu = 16}
                         
                            17 {GroupTable -checkgroup STLMOJ2EEQ01_Admin
                             $Check_Menu = 17}

                            20 { Write-host ' '
                                    Write-host "returning to Main Menu..."
                                    Write-host ' ' 
                              $Check_Menu = 21}


                        } #End of switch


            } Until ($Check_Menu -gt 19) #End of while statement for 'C' option
        
        } #End of Switch Option 'C' Check
        
        
        'X' {
             Write-host " "
             Write-host "Exiting Program" -ForegroundColor Yellow
             Write-host " "
             Start-sleep -s 1
             Write-Host "Thank you! :)" -ForegroundColor Yellow
             Start-sleep -s 2
             Exit
             } #End of 3 - Exit program
     
     }  #End of Switch for $mainmenu


     
}While ($mainmenu -ne 'X') #End of switch for main menu