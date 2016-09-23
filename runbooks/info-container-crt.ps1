workflow container1 {
    param(
     
        [Parameter(Mandatory=$true)]
        [string]
        $credentialName,

        [Parameter(Mandatory=$true)]
        [string]
        $adfStorageAccName,

        [Parameter(Mandatory=$true)]
        [string]
        $adfStorageAccKey
    )
    $Cred = Get-AutomationPSCredential -Name $credentialName

    Add-AzureRmAccount -Credential $Cred
    Login-AzureRmAccount -Credential $Cred
    $storageCtx = New-AzureStorageContext -StorageAccountName $adfStorageAccName -StorageAccountKey $adfStorageAccKey
	
    New-AzureStorageContainer -Name "adfgetstarted" -Context $storageCtx
    
}