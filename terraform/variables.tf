variable "aws_region" {
  default = "eu-west-1"
}

variable "tags" {
  type = map(string)
  default = {
    Project          = "Drail"
    Environment      = "staging"
  }
}

