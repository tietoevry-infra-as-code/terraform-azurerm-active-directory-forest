module "virtual-machine" {
  //  source = "github.com/tietoevry-infra-as-code/terraform-azurerm-virtual-machine?ref=v1.0.0"
  source = "../"
  # Resource Group, location, VNet and Subnet details
  resource_group_name  = "rg-tieto-internal-shared-westeurope-001"
  location             = "westeurope"
  virtual_network_name = "vnet-tieto-internal-shared-dev-westeurope-01"
  subnet_name          = "snet-management-shared-westeurope"


  # This module support multiple Pre-Defined Linux and Windows Distributions.
  # Windows Images: windows2012r2dc, windows2016dc, windows2019dc
  virtual_machine_name               = "vm-testdc"
  os_flavor                          = "windows"
  windows_distribution_name          = "windows2019dc"
  virtual_machine_size               = "Standard_A2_v2"
  admin_username                     = "azureadmin"
  admin_password                     = "Welcome@123$"
  instances_count                    = 1
  private_ip_address_allocation_type = "Static"
  private_ip_address                 = ["10.1.2.4"]
  enable_public_ip_address           = true

  # Active Directory domain and netbios details 
  active_directory_domain       = "capitalmarket.te.local"
  active_directory_netbios_name = "CAPITALMARKET"

  # Network Seurity group port allow definitions for each Virtual Machine
  # NSG association to be added automatically for all network interfaces.
  # SSH port 22 and 3389 is exposed to the Internet recommended for only testing. 
  # For production environments, we recommend using a VPN or private connection
  nsg_inbound_rules = [
    {
      name                   = "rdp"
      destination_port_range = "3389"
      source_address_prefix  = "*"
    },

    {
      name                   = "dns"
      destination_port_range = "53"
      source_address_prefix  = "*"
    },
  ]

  # Adding TAG's to your Azure resources (Required)
  # ProjectName and Env are already declared above, to use them here, create a varible. 
  tags = {
    ProjectName  = "tieto-internal"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}
