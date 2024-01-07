variable "ec2_keyname" {
  description = "Key to use for the instance. Overriden by Env"
  type        = string
  default     = "test"
}

variable "instance" {
  type = map
  default = { #hopefully none of this stuff is intended to be hidden. Next step is to create new ones every time. 
    "ami_id"                  = "ami-0c7217cdde317cfec" #ubuntu
    "type"                    = "t2.micro"
    "name"                    = "tf-test-create"
    "region"                  = "us-east-1"
  }
}
