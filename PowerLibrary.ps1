#Create User(s)
function Create-ADUsers
{

}

#Takes length of designated string length
function Create-RandomString($StringLength)
{
    if($StringLength.Length -lt 1 -or $StringLength -eq $null)
    {
        return "No String Length"
    }

    #Password Length
    $AcceptablePassword = $false
    $charSet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789*?'.ToCharArray()
    $lowerCase = 'abcdefghijklmnopqrstuvwxyz'.ToCharArray()
    $upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.ToCharArray()
    $Numbers = '0123456789'.ToCharArray()
    $Symbols = '*?'.ToCharArray()

    #Loop until an acceptable password is found
    while($AcceptablePassword -eq $false)
    {
        #Set Pasword to nothing
        $password = ""

        #Generate Password
        for ($i = 0 ; $i -lt $StringLength ; $i++) {
            $password += $charSet | Get-Random
        }

        #Check that all domain password requirements are being met
        $CheckForLowerCase = $false
        $CheckForUpperCase = $false
        $CheckForNumber = $false
        $CheckForSymbol = $false

        #Loop through password
        foreach($char in $password.ToCharArray())
        {
            #Lower Case Found
            if($lowerCase.IndexOf($char) -ne "-1")
            {
                $CheckForLowerCase = $true
            }

            #Upper Case Found
            if($upperCase.IndexOf($char) -ne "-1")
            {
                $CheckForUpperCase = $true
            }

            #Number Found
            if($Numbers.IndexOf($char) -ne "-1")
            {
                $CheckForNumber = $true
            }

            #Symbol Found
            if($Symbols.IndexOf($char) -ne "-1")
            {
                $CheckForSymbol = $true
            }
        }

        #Determine if password generated is acceptable
        if($CheckForLowerCase -eq $true -and $CheckForUpperCase -eq $true -and $CheckForNumber -eq $true -and $CheckForSymbol -eq $true)
        {
            $AcceptablePassword = $true
        }
    }

    #Return Password
    return $password
}

#Get all AD Users - All Properties? or Custom Properties?
function Get-AllADUsers($AllProperties, $Properties)
{
    #Create Array for AD Users
    $ADUsers = @()
    #Notable variables that may be useful to the user
    $AmountOfUsers = 0
    $AmountOfEnabledUsers = 0
    $AmountOfDisabledUsers = 0

    #Inform the user that all users are being collected
    Write-Host "Collecting AD User Data"

    #Default All Properties and Group membership to false if null
    if($AllProperties -eq $null)
    {
        $AllProperties = $false
    }

    if($AllProperties -eq $true)
    {
        $ADUsers = Get-ADUser -Filter * -Properties *
    }
    elseif($Properties.count -ne 0 -and $AllProperties -eq $false)
    {
        try
        {
            $ADUsers = Get-ADUser -Filter * -Properties $Properties
        }
        catch
        {
            "Error With Properties Given "
            return $null
        }
    }
    else
    {
        $ADUsers = Get-ADUser -Filter *
    }

    $AmountOfUsers = $ADUsers.Count

    foreach($User in $ADUsers)
    {
        if($User.Enabled)
        {
            $AmountOfEnabledUsers += 1
        }
        else
        {
            $AmountOfDisabledUsers += 1
        }
    }
    
    #Let the user know the function ran and report findings
    Write-Host "All AD User Data has been collected"
    Write-Host "Total Amount of AD Users:" $AmountOfUsers
    Write-Host "Enabled AD Users:" $AmountOfEnabledUsers
    Write-Host "Disabled AD Users:" $AmountOfDisabledUsers

    return $ADUsers
}

function Get-ADUserGroupMembership
{

}

function Help-Library($FunctionInQuestion)
{
    if($FunctionInQuestion = "")
    {
        
    }
}