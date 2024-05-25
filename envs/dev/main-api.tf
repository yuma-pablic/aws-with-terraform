module "api-cluster" {
  source  = "../../modules/backend-cluster"
  service = var.service
  env     = var.env
  vpc_id  = module.network.vpc_id
}
module "api" {
  source  = "../../modules/backend-with-go"
  env     = "dev"
  service = "backend-with-go"
  vpc_id  = module.network.vpc_id
}

module "db" {
  source  = "../../modules/db"
  env     = var.env
  service = var.service
  vpc_id  = module.network.vpc_id
}

module "devops" {
  source  = "../../modules/devops"
  env     = var.env
  service = var.service
  vpc_id  = module.network.vpc_id
}

module "monitoring" {
  source  = "../../modules/manegement"
  env     = var.env
  service = var.service
  vpc_id  = module.network.vpc_id
}