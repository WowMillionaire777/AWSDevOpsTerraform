data "aws_subnet_ids" "subnets" {
  vpc_id = aws_default_vpc.default.id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
//  version                = "~> 1.9"
}

module "in28minutes-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "in28minutes-cluster"
  cluster_version = "1.17"
  subnet_ids         = ["subnet-00377a54c78cb04d1", "subnet-0748f5d0412ddcb71", "subnet-04b70960176d8fd09"] #CHANGE  subnet-00377a54c78cb04d1, subnet-05fbf91cab0e98313
  #subnets = data.aws_subnet_ids.subnets.ids
  vpc_id          = vpc-0cbc98d2667f37c82
  #vpc_id         = "vpc-0cbc98d2667f37c82"

  self_managed_node_groups = [
    {
      instance_type = "t2.micro"
      max_capacity  = 5
      desired_capacity = 3
      min_capacity  = 3
    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.in28minutes-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.in28minutes-cluster.cluster_id
}


# We will use ServiceAccount to connect to K8S Cluster in CI/CD mode
# ServiceAccount needs permissions to create deployments 
# and services in default namespace
resource "kubernetes_cluster_role_binding" "example" {
  metadata {
    name = "fabric8-rbac"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "default"
  }
}

# Needed to set the default region
provider "aws" {
  region  = "us-east-1"
}