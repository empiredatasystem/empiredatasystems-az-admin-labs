Connect-AzAccount

Write-Host "Your Current Subsription where resources are deployed" (Get-AzContext).Subscription.Name

$rgName = "demolab-06-rg"

New-AzResourceGroup -Name $rgName -Location southcentralus

New-AzResourceGroupDeployment -ResourceGroupName $rgName `
 -TemplateFile .\az104-06-vms-template.json -TemplateParameterFile .\az104-06-vm-parameters.json -Verbose