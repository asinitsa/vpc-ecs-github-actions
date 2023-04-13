# vpc-ecs-github-actions

This repo deploys different versions of nginx to specific endpoint. 

To deploy specific version of nginx:

* change value of varible "service-image" in the file variables.tf
* push new version to main branch
* wait about 1 minute
* check deployed version using command 
* `curl -v http://dev-alb-1294002207.eu-central-1.elb.amazonaws.com/  2>&1 | grep Server`

TODO:

* improve security, fix problem listed in terrascan report
* create HTTPS endpoint
* reduce IAM permissions for the task
* encrypt RDS password and storage 
* create CloudWatch alerts based on metrics and logs


