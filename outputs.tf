output "clusters" { value = { for cluster in var.clusters : cluster.name => vsphere_compute_cluster.clusters } }
output "licenses" { value = vsphere_license.license }
output "license_disclaimer" { value = "Until the terraform provider supports it, you will have to manually name the licenses if you want human friendly names" }

output "dc_id" {
  value     = vsphere_datacenter.dc.moid
  sensitive = true
}
