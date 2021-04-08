resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = var.tags
}


resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "cluster_resource_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}



resource "aws_eks_cluster" "k8s_cluster" {
  name     = "k8s_candy_cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = module.vpc.public_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.cluster_resource_controller,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.k8s_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.k8s_cluster.certificate_authority[0].data
}

resource "aws_eks_node_group" "cluster_nodes" {
  cluster_name    = aws_eks_cluster.k8s_cluster.name
  node_group_name = "k8s_nodes"
  node_role_arn   = aws_iam_role.cluster_nodes_role.arn
  subnet_ids      = module.vpc.public_subnets
  capacity_type = "SPOT"
  #instance_types = ["c5.xlarge"] //We need to go cheaper
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 4
    min_size     = 1
  }

}

resource "aws_iam_role" "cluster_nodes_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "ng_worker_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.cluster_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "ng_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.cluster_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "ng_resistry_access_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.cluster_nodes_role.name
}