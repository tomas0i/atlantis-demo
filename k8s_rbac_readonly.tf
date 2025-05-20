

resource "aws_iam_role" "eks_readonly" {
  name = "${local.cluster_name}-eks-readonly"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "eks_readonly" {
  #name = "AmazonEKSAdminPolicy"
  name = "${local.cluster_name}-eks-readonly-policy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:ListClusters"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "eks.amazonaws.com"
                }
            }
        }
    ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "eks_readonly" {
  role = aws_iam_role.eks_readonly.name
  policy_arn = aws_iam_policy.eks_readonly.arn
}





resource "aws_iam_policy" "eks_assume_readonly" {
  #name = "AmazonEKSAssumeAdminPolicy"
  name = "${local.cluster_name}-assume-readonly-policy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": "${aws_iam_role.eks_readonly.arn}"
        }
    ]
}
POLICY
}

resource "aws_iam_user" "readonly_user_test" {
  name = "readonly_user"
}

resource "aws_iam_user_policy_attachment" "readonly_user_test" {
  user = aws_iam_user.readonly_user_test.name
  policy_arn = aws_iam_policy.eks_assume_readonly.arn
}

resource "aws_eks_access_entry" "readonly_entry" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = aws_iam_role.eks_readonly.arn
  kubernetes_groups = ["readonly-grp"]
}

resource "aws_iam_group" "eks_readonly" {
  name = "eks_readonly"
}

resource "aws_iam_user_group_membership" "example1" {
  user = aws_iam_user.readonly_user_test.name

  groups = [
    aws_iam_group.eks_readonly.name,
  ]
}
