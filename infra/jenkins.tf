### To provision Jenkins Master ###

resource "google_compute_instance" "jenkins-master-1" {
   name = "jenkins-master-1"
   machine_type = "f1-micro"
   zone = "us-west1-a"
   tags = ["jenkins"]
   boot_disk {
      initialize_params {
      image = "ubuntu-1604-lts"
   }
}
network_interface {
   network = "default"
   access_config {}
}
service_account {
   scopes = ["userinfo-email", "compute-ro", "storage-ro"]
   }

 metadata_startup_script = <<SCRIPT
apt install -y update
apt install -y docker.io
systemctl enable docker
systemctl start docker
docker pull toanc/jenkins-master:latest
docker run -d -p 8080:8080 -p 50000:50000 --name master-1 toanc/jenkins-master
wget https://raw.githubusercontent.com/eficode/wait-for/master/wait-for -P /tmp
chmod +x /tmp/wait-for
/bin/sh /tmp/wait-for localhost:8080 -t 90
sleep 90
i=`hostname --ip-address`
f=`docker exec -i master-1 bash -c 'java -jar /tmp/jenkins-cli.jar -s http://localhost:8080 -remoting groovy /tmp/findkey --username admin --password admin'`

echo $f > /tmp/checkf
curl -X POST https://api.keyvalue.xyz/[HIDED]/--data ' ip: '$i' secret: '$f' '
SCRIPT

 metadata {
    sshKeys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
   }
}
