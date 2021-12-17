resource "vsphere_datacenter" "dc" { name = var.datacenter_name }

resource "vsphere_compute_cluster" "clusters" {
  for_each                      = var.clusters
  datacenter_id                 = vsphere_datacenter.dc.moid
  drs_advanced_options          = lookup(each.value, "drs_advanced_options", {})
  drs_automation_level          = lookup(each.value, "drs_automation_level", "fullyAutomated")
  drs_enabled                   = tobool(lookup(each.value, "drs_enabled", true))
  ha_admission_control_policy   = lookup(each.value, "ha_admission_control_policy", "disabled")
  ha_enabled                    = tobool(lookup(each.value, "ha_enabled", true))
  ha_heartbeat_datastore_policy = lookup(each.value, "ha_heartbeat_datastore_policy", "allFeasibleDs")
  ha_host_monitoring            = lookup(each.value, "ha_host_monitoring", "disabled")
  ha_vm_component_protection    = lookup(each.value, "ha_vm_component_protection", "disabled")
  ha_advanced_options           = { "das.ignoreRedundantNetWarning" = "true" }
  name                          = each.key
  lifecycle { ignore_changes = [host_system_ids,ha_vm_restart_priority] }
  # TODO: there is a lot you can do with this resource and my use case is simple; this is worth expanding for feature parity
}

resource "vsphere_license" "license" {
  for_each    = var.licenses
  license_key = each.key
  labels = {
    VpxClientLicenseLabel = each.value
    Workflow              = each.value
    WebClientLabel        = each.value
  }
}
