module "networks" {
    source = "./modules/networks"
    vpc_cidr = var.vpc_cidr
    public_subnets = {
      "1" = "10.0.1.0/24",
      "2" = "10.0.2.0/24"
    }
    private_subnets = {
      "3" = "10.0.3.0/24",
      "4" = "10.0.4.0/24"
    }
    public_subnet_nat = module.networks.public_subnets[0]
    rt_public_subnets = [module.networks.public_subnets[0],module.networks.public_subnets[1]]
    rt_private_subnets = [module.networks.private_subnets[0],module.networks.private_subnets[1]]
}





module "private_ec2" {
    source = "./modules/ec2_private"
    vpc_id = module.networks.vpc_id
    instance_type = var.instance_type
    public_ = false
    count = length(module.networks.private_subnets)
    subnet_id = module.networks.private_subnets[count.index]
    key_name = var.key_name
    user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install nginx -y
    sudo systemctl start nginx
    sudo systemctl enable nginx
    sudo chmod 777 /var/www/html
    sudo chmod 777 /var/www/html/index.nginx-debian.html
    sudo echo '<h1>saad from private instance </h1>' > /var/www/html/index.nginx-debian.html
    sudo systemctl restart nginx
    EOF
    depends_on = [
      module.networks.nat_id
    ]
 }

module "public_ec2" {
    source = "./modules/ec2"
    vpc_id = module.networks.vpc_id
    count = length(module.networks.public_subnets)
    subnet_id = module.networks.public_subnets[count.index]
    instance_type = var.instance_type
    public_ = true
    key_name = var.key_name
    connection_user        = var.connection_user
    connection_private_key = "./ssh-1.pem"
    file_source            = "./script.sh"
    file_destination       = "/tmp/script.sh"
    inline                 = ["chmod 777 /tmp/script.sh", "/tmp/script.sh ${module.NLB.Load_Balancer_DNS}"]
   
}

module "alb_targetgroup" {
  source             = "./modules/target_groups"
  ec2_ids             = module.public_ec2[0].instance_id
  vpcid              = module.networks.vpc_id
  protocol = "HTTP"
  protocol_heath = "HTTP"
  target_name        = "application"
  depends_on = [
    module.public_ec2[0].instance_id
   
  ]
}
module "alb_targetgroup-1" {
  source             = "./modules/target_groups"
  ec2_ids             = module.public_ec2[1].instance_id
  vpcid              = module.networks.vpc_id
  protocol = "HTTP"
  protocol_heath = "HTTP"
  target_name        = "application"
  depends_on = [
    module.public_ec2[1].instance_id
   
  ]
}

module "ALB" {
  source            = "./modules/alb"
  name              = "ALB"
  vpc_id            = module.networks.vpc_id
  subnets           = module.networks.public_subnets
  target_group_arn  = module.alb_targetgroup.Targetgroup_arn
  depends_on = [
    module.alb_targetgroup.Targetgroup_arn
  ]
}

module "nlbtargetgroup" {
  source             = "./modules/target_groups"
  ec2_ids            = module.private_ec2[0].private_instance_id
  vpcid              = module.networks.vpc_id
  protocol = "TCP"
  protocol_heath = "TCP"
  target_name        = "network"
  depends_on = [
    module.private_ec2[0].private_instance_id
  ]
}
module "nlbtargetgroup-1" {
  source             = "./modules/target_groups"
  ec2_ids            = module.private_ec2[1].private_instance_id
  vpcid              = module.networks.vpc_id
  protocol = "TCP"
  protocol_heath = "TCP"
  target_name        = "network"
  depends_on = [
    module.private_ec2[1].private_instance_id
  ]
}


module "NLB" {
  source            = "./modules/nlb"
  name              = "NLB"
  vpc_id            = module.networks.vpc_id
  subnets           = module.networks.private_subnets
  target_group_arn  = module.nlbtargetgroup.Targetgroup_arn
  depends_on = [
    module.nlbtargetgroup.Targetgroup_arn
  ]

}

locals {
  allmyinfo = {
    public_ip_1 = module.public_ec2[0].public_ip
    public_ip_2 = module.public_ec2[1].public_ip
    url_alb  = module.ALB.Load_Balancer_DNS
    private_ip_1 = module.private_ec2[0].private_ip
    private_ip_1 = module.private_ec2[1].private_ip
  }
}
resource "local_file" "ips_list" {
    
    content = jsonencode(local.allmyinfo)
    filename = "./mydata.json"
  
}


  

