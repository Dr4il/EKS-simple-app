resource "aws_ecr_repository" "image_registry" {
  name                 = "candy_registry"
  image_tag_mutability = "MUTABLE"

}
