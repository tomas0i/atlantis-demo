# Atlantis Demo

## Prerequisites:


- generate  access token for github :https://www.runatlantis.io/docs/access-credentials.html#github-user
- deploy terraform   backend resources : https://github.com/tomas0i/atlantis-demo/blob/main/prep/tf_backend/backend.tf
 ![img.png](images/img.png)
  upadate terraform backend config with s3 bucket name in https://github.com/tomas0i/atlantis-demo/blob/main/terraform.tf#L3
- set up required secrets in AWS secrets manager:
  name should match: one defined in variables.tf :
  https://github.com/tomas0i/atlantis-demo/blob/main/variables.tf#L20

  github token ,
  atlantis secret,
  aws credentials (with enough permissions for atlantis to execute terraform)
  
  ![img.png](images/secrets.png)
  (can be created from terraform:
  https://github.com/tomas0i/atlantis-demo/blob/main/prep/secrets/secrets.tf

## Deploy EKS cluster and atlantis helm chart with terraform

Binary downloads of the Helm client can be found on [the Releases page](https://github.com/helm/helm/releases/latest).

Unpack the `helm` binary and add it to your PATH and you are good to go!

If you want to use a package manager:

- execute terarform init, terraform plan  and apply from main directory
  once resources created, note the value of atlantis_load_balancer_hostname output:
  ![img.png](images/lb_hostname.png)
  and update atlantisUrl value vith http://<output value>:
  ![img.png](images/lb_hostname2.png)
  in https://github.com/tomas0i/atlantis-demo/blob/main/atlantis.tf#L39
  and run terraform apply once again
  (more suitable approach would be to register domain and use Rout53 entry)

## Finish atlantis configuration in github repo

- add webhook as described here : https://www.runatlantis.io/docs/configuring-webhooks.html
  use http:://<atlantis_load_balancer_hostname> and atlantis_secret values from AWS secret manager

## Verify