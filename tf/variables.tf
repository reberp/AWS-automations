variable "instance-ami" {
  type = string
  default = "ami-0c7217cdde317cfec"
}

variable "ec2_keyname" {
  description = "The type of the instance"
  type        = string
  default     = "test"
}

variable "instance" {
  type = map
  default = { #hopefully none of this stuff is intended to be hidden. Next step is to create new ones every time. 
    "ami-id"                  = "ami-0c7217cdde317cfec"
    "type"                    = "t2.micro"
    "name"                    = "tf-test-create"
    "region"                  = "us-east-1"
    "keyname"                 = ""
    #"vpc-security-group-ids"  = ""
    #"subnet-id"               = ""      
  }
}
