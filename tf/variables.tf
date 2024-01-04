variable "instance-ami" {
  type = string
  default = "ami-0c7217cdde317cfec"
}

variable "instance" {
  type = map
  default = {
    "ami-id" = "ami-0c7217cdde317cfec"
    "type"  = "t2.micro"
    "name"  = "tf-test-create"
    "region" = "us-east-1"
  }
}
