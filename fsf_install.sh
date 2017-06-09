#!/bin/bash
# Install FSF on Docker

# Define a banner to separate sections
banner="========================================================================="
header() {
        echo
        printf '%s\n' "$banner" "$*" "$banner"
}

# Check for prerequisites
if [ "$(id -u)" -ne 0 ]; then
        echo "This script must be run using sudo!"
        exit 1
fi
DOCKERHUB="wlambert"
REPO="fsf"
URL="https://github.com/weslambert/$REPO.git"

header "Performing apt-get update"
apt-get update > /dev/null
echo "Done!"


header "Installing git"
apt-get install -y git > /dev/null
echo "Done!"

header "Installing Docker"
apt-get -y install apt-transport-https ca-certificates curl > /dev/null
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
apt-get update > /dev/null
apt-get -y install docker-ce > /dev/null
echo "Done!"

header "Downloading Docker container"
docker pull $DOCKERHUB/fsf
#echo "export DOCKER_CONTENT_TRUST=1" >> /etc/profile.d/securityonion-docker.sh
#export DOCKER_CONTENT_TRUST=1

# Create directories and assign perms
mkdir -p /opt/fsf/extracted/
mkdir -p /opt/fsf/error/
mkdir -p /opt/fsf/output/
mkdir -p /opt/fsf/pending/
mkdir -p /opt/fsf/processed/
mkdir -p /var/log/fsf
chown -R 1000:1000 /opt/fsf/extracted/
chown -R 1000:1000 /opt/fsf/error/
chown -R 1000:1000 /opt/fsf/output/
chown -R 1000:1000 /opt/fsf/pending/
chown -R 1000:1000 /opt/fsf/processed/
chown -R 1000:1000 /var/log/fsf/


git clone $URL

cp $REPO/Docker/Dockerfile /opt/fsf/Dockerfile
cp -av $REPO/etc/cron.d/fsf /etc/cron.d/fsf
cp -av $REPO/usr/sbin/fsf-start /usr/sbin/fsf-start
cp -av $REPO/process.sh /opt/fsf/extracted/process.sh
chmod +x /etc/cron.d/fsf
chmod +x /opt/fsf/extracted/process.sh

cd /opt/fsf/
