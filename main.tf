provider "aws" {
}

resource "aws_iam_user" "givi" {
  name = var.dev_users[count.index]
  tags = {
    Description = "${var.dev_users[count.index]} with "
  }
  count = length(var.dev_users)
}

resource "aws_iam_user" "slava" {
  name = var.devOps_users[count.index]
  tags = {
    Description = "obana ${var.devOps_users[count.index]} "
  }
  count = length(var.devOps_users)
}

resource "aws_iam_user_group_membership" "devOps-group-member" {
  user = aws_iam_user.slava[count.index].name#!!!!!!
  count = length(var.devOps_users)
  groups = [
    aws_iam_group.devOps-group.name,
  ]
}

resource "aws_iam_user_group_membership" "attach-givi-to-devOps" {
  user = aws_iam_user.givi[0].name
  groups = [
    aws_iam_group.devOps-group.name,
  ]
}


resource "aws_iam_user_group_membership" "dev-group-member" {
  user = aws_iam_user.givi[count.index].name
  count = length(var.dev_users)
  groups = [
    aws_iam_group.dev-group.name,
  ]
}


resource "aws_iam_group" "dev-group" {
  name = "developer_group"
}
resource "aws_iam_group" "devOps-group" {
  name = "devOps_groupp"
}




resource "aws_iam_policy" "givi_selin" {
  name   = "givi_selin"
  path   = "/"
  policy = file("./dev_policy.json")
}

resource "aws_iam_policy" "slava_rita" {
  name   = "slava_rita"
  path   = "/"
  policy = file("./devOps_policy.json")
}



resource "aws_iam_policy_attachment" "attached_to_givi_selin" {
  name       = "attachment1"
  #users      = [var.devOps_users[0]]
  groups = [aws_iam_group.dev-group.name]
  policy_arn = aws_iam_policy.givi_selin.arn
}


resource "aws_iam_policy_attachment" "attached_to_slava_rita" {
  name       = "attachment2"
  #users      = concat(var.devOps_users) #for list concatination 
  groups = [aws_iam_group.devOps-group.name]
  policy_arn = aws_iam_policy.slava_rita.arn
}




# data "aws_iam_policy_document" "givi_selin" {
#   statement {
#     effect    = "Allow"
#     actions   = ["ec2:Describe*"]
#     resources = ["*"]
#   }
# }


# resource "aws_iam_access_key" "givi" {
#   user = aws_iam_user.givi.name  
# }


# resource "aws_iam_user_policy" "test_policy" {
#   name   = "test"
#   user   = aws_iam_user.givi.name
#   policy = data.aws_iam_policy_document.test_policy.json
# }



