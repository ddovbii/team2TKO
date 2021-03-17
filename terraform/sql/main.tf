terraform {
  required_providers {
    azurerm = {
      version = "2.40"
    }
  }
}

provider azurerm {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "sqlsvr-${var.sandbox_id}-rg"
  location = ${var.location}
}

resource "azurerm_sql_server" "default" {
  name                = "sqlsvr-${var.sandbox_id}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  location            = "${azurerm_resource_group.default.location}"
  version                      = "12.0"
  administrator_login          = random_string.sqlUserIdMaster.result
  administrator_login_password = random_string.sqlPasswordMaster.result
}

resource "azurerm_sql_database" "default" {
  name                             = "db-${var.sandbox_id}"
  resource_group_name              = "${azurerm_resource_group.default.name}"
  location                         = "${azurerm_resource_group.default.location}"
  server_name                      = "${azurerm_sql_server.default.name}"
  edition                          = "Basic"
  collation                        = "SQL_Latin1_General_CP1_CI_AS"
  create_mode                      = "Default"
  requested_service_objective_name = "Basic"
}

resource "azurerm_sql_firewall_rule" "default" {
  name                = "allow-azure-services"
  resource_group_name = "${azurerm_resource_group.default.name}"
  server_name         = "${azurerm_sql_server.default.name}"
  start_ip_address    = "0.0.0.0" # Allow access to Azure services
  end_ip_address      = "0.0.0.0"
}

resource "random_string" "sqlUserIdMaster" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  number  = false
}

resource "random_string" "sqlPasswordMaster" {
  length  = 19
  special = false
  upper   = true
  lower   = true
}