resource "aws_iam_role" "splunk_role" {
  name = "splunk-role-${random_id.random.hex}"
  path = "/"
  tags = merge(
    local.common_tags,
    {
      "Name" = "splunk-role-${random_id.random.hex}"
    },
  )

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "splunk_policy" {
  name = "splunk-policy-${random_id.random.hex}"
  role = aws_iam_role.splunk_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "ec2:DeleteSubnet",
                "ec2:DeleteRouteTable",
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:DeleteVolume",
                "ec2:StartInstances",
                "ec2:DeleteInternetGateway",
                "ec2:UnassignPrivateIpAddresses",
                "ec2:CreateTags",
                "ec2:RunInstances",
                "ec2:DetachInternetGateway",
                "ec2:AssignPrivateIpAddresses",
                "ec2:StopInstances",
                "ec2:DisassociateRouteTable",
                "ec2:ReplaceNetworkAclAssociation",
                "ec2:CreateVolume",
                "ec2:CancelSpotInstanceRequests",
                "ec2:GetPasswordData",
                "ec2:DeleteVpc",
                "ec2:AssociateAddress",
                "ec2:DeleteNetworkAclEntry",
                "ec2:RequestSpotInstances",
                "ec2:ModifyImageAttribute",
                "ec2:GetConsoleOutput",
                "ec2:DeleteNetworkAcl",
                "ec2:TerminateInstances",
                "ec2:DeleteRoute",
                "ec2:AllocateAddress",
                "ec2:DeleteSecurityGroup",
                "ec2:CreateSecurityGroup",
                "iam:ListRoles",
                "iam:GetRole",
                "iam:ListAttachedRolePolicies",
                "iam:GetUser",
                "iam:GetLoginProfile",
                "iam:ListMFADevices",
                "iam:ListAccessKeys",
                "iam:ListUserPolicies",
                "iam:ListAttachedUserPolicies",
                "iam:GetAccountPasswordPolicy",
                "iam:ListVirtualMFADevices",
                "iam:ListUsers",
                "iam:ListMFADevices",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:ListPolicy",
                "iam:ListEntitiesForPolicy",
                "iam:GetAccessKeyLastUsed",
                "iam:ListPolicies",
                "iam:ListEntitiesForPolicy",
                "cloudtrail:DescribeTrails",
                "ec2:DescribeVpcs",
                "ec2:DescribeSecurityGroups",
                "config:DescribeConfigurationRecorders",
                "config:DescribeDeliveryChannels",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation",
                "s3:GetBucketLogging",
                "s3:GetBucketPolicy",
                "s3:GetEncryptionConfiguration",
                "cloudwatch:DescribeAlarmsForMetric",
                "sns:GetTopicAttributes"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "splunk_instance_profile" {
  name = "splunk-instance-profile-${random_id.random.hex}"
  role = aws_iam_role.splunk_role.name
}