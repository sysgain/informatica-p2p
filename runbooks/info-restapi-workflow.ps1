param(
        [Parameter(Mandatory=$true)]
        [string]
        $ip,

        [Parameter(Mandatory=$true)]
        [string]
        $credentialName,

        [Parameter(Mandatory=$true)]
        [string]
        $client_id,

        [Parameter(Mandatory=$true)]
        [string]
        $sysgain_ms_email,

        [Parameter(Mandatory=$true)]
        [string]
        $sysgain_ms_password,

        [Parameter(Mandatory=$true)]
        [string]
        $informatica_user_name,

        [Parameter(Mandatory=$true)]
        [string]
        $informatica_user_password,

        [Parameter(Mandatory=$true)]
        [string]
        $informatica_csa_vmname,

        [Parameter(Mandatory=$true)]
        [string]
        $adfStorageAccName,

        [Parameter(Mandatory=$true)]
        [string]
        $adfStorageAccKey

)
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

    Write-Output "Logging into Sysgain..."
    Write-Output "------------------------------------------------------"

    #$msLoginUrl="https://138.91.243.84:10011/api/users/v1/components/login"
    $msLoginUrl="https://$ip/api/users/v1/components/login"

    $headLogin = @{
        'Accept' = 'application/json'
    }

    $bodyLogin = @{
        username = "$sysgain_ms_email"
        password = "$sysgain_ms_password"
        grant_type = "password"
        connection_type = "Username-Password-Authentication"
        scope = "openid"
        client_id = "$client_id"
    }

    $bodyJsonLogin = $bodyLogin | ConvertTo-Json

    $auth0 = Invoke-RestMethod -Uri $msLoginUrl -Method Post -Headers $headLogin -Body $bodyJsonLogin -ContentType 'application/json'

    Write-Output "Logging into informatica..."
    Write-Output "------------------------------------------------------"

    #Login into Informatica

    #$infoLoginUrl = "https://138.91.243.84:10011/api/users/v1/components/informatica/login"
    $infoLoginUrl = "https://$ip/api/users/v1/components/informatica/login"

    $infoheadLogin = @{
        'Authorization' = 'bearer '+$auth0.id_token
    }

    $infobodyLogin = @{
        username = "$informatica_user_name"
        password = "$informatica_user_password"
    }
    
    $infobodyJsonLogin = $infobodyLogin | ConvertTo-Json

    $responseLogin = Invoke-RestMethod -Uri $infoLoginUrl -Method Post -Headers $infoheadLogin -Body $infobodyJsonLogin -ContentType 'application/json'

    $icSessionId = $responseLogin.infoData.icSessionId
    $serverUrl = $responseLogin.infoData.serverUrl
    $authToken = $responseLogin.auth0_token

    Write-Output "------------------------------------------------------"
    Write-Output "Logged in successfully..."
    Write-Output "------------------------------------------------------"

    Write-Output "The session id is "$icSessionId
    Write-Output "------------------------------------------------------"
    Write-Output "The server url is "$serverUrl
    Write-Output "------------------------------------------------------"
    Write-Output "The auth token is "$authToken



 



    $Cred = Get-AutomationPSCredential -Name $credentialName

    Add-AzureRmAccount -Credential $Cred
    Login-AzureRmAccount -Credential $Cred
    $storageCtx = New-AzureStorageContext -StorageAccountName $adfStorageAccName -StorageAccountKey $adfStorageAccKey
	
    New-AzureStorageContainer -Name "adfgetstarted" -Context $storageCtx



    


    #$workflowUrl = "https://138.91.243.84:10011/api/users/v1/components/informatica/workflow/ignitep2p"
    $workflowUrl = "https://$ip/api/users/v1/components/informatica/workflow/ignitep2p"

    $workflowHead = @{
        'Accept' = 'application/json'
        'Authorization' = 'bearer '+$auth0.id_token
    }

    $workflowBody = @{
        sessionId = "$icSessionId"
        serverUrl = "$serverUrl"
        csa_name = "$informatica_csa_vmname"
        storageAccountName = "$adfStorageAccName"
        storageAccountKey = "$adfStorageAccKey"
    }

    $workflowBodyJson = $workflowBody | ConvertTo-Json

    $workres = Invoke-RestMethod -Uri $workflowUrl -Method Post -Headers $workflowHead -Body $workflowBodyJson -ContentType 'application/json'

    Write-Output $workres | ConvertTo-Json






