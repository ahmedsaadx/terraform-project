module "backend_" {
    source = "./modules/backend"
    bucket_name = "state-terraform-saad-2000"
    dynamo_name = "table"
  
}



terraform {
  backend "s3"{
    bucket = "state-terraform-saad-2000"
    key = "dev/"
    region = "us-east-1"
    dynamodb_table = "table"
    encrypt = true
    
  }
}