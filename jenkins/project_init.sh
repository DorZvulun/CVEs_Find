#! /bin/bash

# read admin user
echo -e "Enter Admin User for Jenkins (default: admin) "
#read username

# read admin password
echo -e "Enter Admin Password for Jenkins (default: admin) "
#read password

if [[ -z "${username}" ]]; then
    username=admin
fi
if [[ -z "${password}" ]]; then
    password=admin
fi

# Export Envs
export JENKINS_ADMIN_ID=${username}

export JENKINS_ADMIN_PASSWORD=${password}

# run docker compose
pushd Jenkins
docker compose up -d
