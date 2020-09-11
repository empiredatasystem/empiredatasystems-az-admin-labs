Connect-AzAccount

Write-Host "Your Current Subsription where resources are deployed" (Get-AzContext).Subscription.Name

$rgName = "demolab-08-rg"

New-AzResourceGroup -Name $rgName -Location eastus

New-AzResourceGroupDeployment -ResourceGroupName $rgName `
 -TemplateFile .\az104-11-vm-template.json -TemplateParameterFile .\az104-11-vm-parameters.json -Verbose