resource "azurerm_log_analytics_workspace" "la" {
  name                = "log-analytics"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "vm_diag" {
  name                       = "vm-diag"
  target_resource_id         = var.vm_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la.id

  logs {
    category = "PerformanceCounters"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}