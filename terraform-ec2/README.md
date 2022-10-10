## Ec2 docker installing and application deployment
in this challenge we can deploy our application on ec2 instance.

```sh
cd terraform-aws-ec2/terraform-ec2

terraform init
terraform plan
terraform apply --auto-approve
```

## for destroy infrastracture
```sh
terraform destroy --auto-approve
```