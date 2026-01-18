terraform {
    required_version = ">= 1.14.0"

    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = ">= 4.57.0"
        }
    }

    backend "remote" {
        hostname = "app.terraform.io"
        organization = "forsakenidol-organization-1"
        workspaces {
            name = "deb-repo"
        }
    }

}
