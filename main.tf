#------------------------------------
# Terraform configuration
# Terraformのバージョン固定
# プロバイダーバージョンの固定
# "~>" は5.0.0以上かつ6.0.0未満のバージョンが許可されるという意味
#------------------------------------
terraform {
  required_version = ">=1.6.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
  backend "s3" {
    bucket  = "tfstate-bucket-674078804300"
    key     = "dev.tfstate"
    region  = "ap-northeast-1"
    profile = "Administrator"
  }
}

#------------------------------------
# Provider
#------------------------------------
provider "aws" {
  #credentialsに登録しているユーザーを設定する
  profile = "Administrator"
  region  = "ap-northeast-1"

}

#------------------------------------
# Variables
#------------------------------------
variable "project" {
  type = string
}

variable "environment" {
  type = string
}
