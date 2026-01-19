resource "azurerm_resource_group" "apt_resources" {
    name = "apt-repo-resources"
    location = "Australia East"
}

resource "azurerm_storage_account" "apt_storage_account" {
    name = "forsakenidoldebianstorageaccount"
    resource_group_name = azurerm_resource_group.apt_resources.name
    location = azurerm_resource_group.apt_resources.location
    account_tier = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_storage_container" "apt_storage_container" {
    name = "debrepo"
    storage_account_id = azurerm_storage_account.apt_storage_account.id
    container_access_type = "container"

}

output "apt_storage_account_id" {
    value = azurerm_storage_account.apt_storage_account.id
}

output "apt_storage_account_endpoint" {
    value = azurerm_storage_account.apt_storage_account.primary_blob_endpoint
}
