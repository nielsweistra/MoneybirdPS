$global:authurl = "https://moneybird.com/oauth/authorize"
$global:apiUrl = "https://moneybird.com/api/v2"

$clientId = ""
$clientSecret = ""

$global:MoneybirdId = ""

$global:headers = @{
    Authorization = "Bearer "
}

$global:MBDefaultAdministration = 0

function Set-DefaultAdministration {
    param (
        [Parameter()]
        [int]
        $global:MBDefaultAdministration
    )

    Get-MBAdministrations | format-list
    $global:MBDefaultAdministration = 0
    
}

function Get-MBDefaultAdministration {
    param (
        [Parameter()]
        [int]
        $global:MBDefaultAdministration
    )
    Get-MBAdministrations.[$global:MBDefaultAdministration]
    
}

function Get-MBMutations {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $moneybirdId 
    )

    if ([string]::IsNullOrEmpty($moneybirdID)) {
        $moneybirdId = (Get-MBAdministrations)[$global:MBDefaultAdministration].id
    }

    try {
        $Uri = [string]::Format('{0}/{1}/{2}', $global:apiUrl, $moneybirdId, "financial_mutations.json?filter=period%3Athis_month") 
        $req = Invoke-RestMethod -Method Get -Uri $Uri -Headers $headers -ContentType "application/json"
        return $req
    }
    catch [exception] {     
    }
    
}

function Get-MBAdministrations {
    try {

        $Uri = [string]::Format('{0}/{1}', $global:apiUrl, "administrations.json")
        $req = Invoke-RestMethod -Method Get -Uri $Uri -Headers $global:headers -ContentType "application/json"

        return $req    
    }
    catch [exception] {   
    }
    
}
function Get-MBContacts {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $moneybirdId 
    )

    if ([string]::IsNullOrEmpty($moneybirdID)) {
        $moneybirdId = (Get-MBAdministrations)[$global:MBDefaultAdministration].id
    }

    try {
        $Uri = [string]::Format('{0}/{1}/{2}', $global:apiUrl, $moneybirdId, "contacts.json")
        $req = Invoke-RestMethod -Method Get -Uri $Uri -Headers $global:headers -ContentType "application/json"

        return $req
    }
    catch [exception] {   
        Write-Error $_.Exception.Message
    }
    
}

function Get-MBContactsId {
    [CmdletBinding()]
    param (
        
    )
    
    $req = Get-MBContacts | sort-object @{e = { $_.customer_id -as [int] } } | format-table company_name, customer_id
    return $req
}
