output "server_name" {
  value = "${azurerm_sql_server.default.fully_qualified_domain_name}"
}