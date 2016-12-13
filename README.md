## Provisioning

### vagrant
    vagrant up

### Terraform
Make sure to rename secret.tf.dist to secret.tf and insert a DO API token.
    TENV=STG1; TDC=nyc2; terraform plan -var env=$TENV -var dc=$TDC -state=$TENV.state

## Prerequisites

### Vagrant Host Manager plugin
    vagrant plugin install vagrant-hostmanager

### Python Modules
    pip install dopy
    pip install six
