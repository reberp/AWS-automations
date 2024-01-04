Testing combination of ansible and terraform for configuration of AWS cluster for other things (maybe [the blog deployment](https://github.com/reberp/personal-blog), or recreating in TF the [content in the SysOps course](https://github.com/reberp/aws-soa-code)). Going to eventually provision a K8s cluster. 

Next step: 
* adding the VM network config w/ TF (VPC/SG/Keys, etc) 
* configuring the VM. Intending to use ansible roles.


Req Ansible and TF as well as AWS key environment variables as AWS_SECRET_ACCESS_KEY, AWS_ACCESS_KEY_ID, or better though [aws configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) to set the .aws/credentials file. 

Links: 
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
https://docs.ansible.com/ansible/latest/collections/community/general/terraform_module.html#examples
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build
