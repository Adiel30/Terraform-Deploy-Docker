# volume setup
sudo su
sudo yum -y install wget zip unzip file
yum -y update
vgchange -ay

DEVICE_FS=`blkid -o value -s TYPE ${DEVICE}`
if [ "`echo -n $DEVICE_FS`" == "" ] ; then 
   #wait for the device to be attached
  DEVICENAME=`echo "${DEVICE}" | awk -F '/' '{print $3}'`
  DEVICEEXISTS=''
  while [[ -z $DEVICEEXISTS ]]; do
    echo "checking $DEVICENAME"
    DEVICEEXISTS=`lsblk |grep "$DEVICENAME" |wc -l`
    if [[ $DEVICEEXISTS != "1" ]]; then
      sleep 15
    fi
  done
  pvcreate ${DEVICE}
  vgcreate data ${DEVICE}
  lvcreate --name volume1 -l 100%FREE data
  mkfs.ext4 /dev/data/volume1
fi

mkdir -p /var/lib/jenkins
echo '/dev/data/volume1 /var/lib/jenkins ext4 defaults 0 0' >> /etc/fstab
mount /var/lib/jenkins

# install java
yum -y update
yum -y install java-1.8.0-openjdk


# install jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum -y install jenkins

# install docker
sudo yum -y install docker

# install python pip
export PATH=/root/.local/bin:$PATH
sudo yum -y install python3
wget -q https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user
export PATH=/usr/local/bin:$PATH
# install aws
pip3 install awscli --user
export PATH=/usr/local/bin:$PATH

# install terraform
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
export PATH=/usr/local/bin/:$PATH
tfswitch 0.11.9
yum install git -y




# start services
sudo service jenkins start
sudo chkconfig jenkins on
#sudo systemctl enable docker.service
#sudo systemctl start docker.service