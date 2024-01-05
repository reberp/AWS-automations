Testing combination of ansible and terraform for configuration of AWS cluster for other things (maybe [the blog deployment](https://github.com/reberp/personal-blog), or recreating in TF the [content in the SysOps course](https://github.com/reberp/aws-soa-code)). Going to eventually provision a K8s cluster. 

Status:
* Creates the VPC, Subnet, SG, RT, GW, associations so VM can be internet connected
* Creates VMs with public ips
* Updates the inventory and confirms they're accessible

Next step: 
* configuring the VM. Intending to use ansible roles - for kubeadm base and then addons flux helm etc. 

Req:
* Set the keyname you want to use as TF_VAR_ec2_keyname
* Req Ansible and TF as well as AWS key environment variables as AWS_SECRET_ACCESS_KEY, AWS_ACCESS_KEY_ID, or better though [aws configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) to set the .aws/credentials file. 

Run:
```
ansible-playbook tasks/main.yml -i inventory/hosts
#terraform -chdir=tf/ plan 
```

Links: 
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
https://docs.ansible.com/ansible/latest/collections/community/general/terraform_module.html#examples
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build
https://spacelift.io/blog/how-to-use-terraform-variables