resource "aws_key_pair" "agent_key" {
  public_key = var.public_key
}

resource "aws_instance" "agent" {
  ami                    = "ami-0df7a207adb9748c7"
  instance_type          = var.instance_type
  key_name               = aws_key_pair.agent_key.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.agent_sg_id]

  user_data = <<-EOF
#!/bin/bash
sudo apt update
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo apt install default-jre -y
sudo adduser --disabled-password --gecos "" jenkins
sudo usermod -a -G docker jenkins
sudo mkdir -p /home/jenkins/.ssh
sudo mkdir -p /home/jenkins/remote_agent
sudo bash -c 'echo "${var.public_key}" > /home/jenkins/.ssh/authorized_keys'
sudo chown jenkins:jenkins -R /home/jenkins/.ssh
sudo chown jenkins:jenkins -R /home/jenkins/remote_agent
EOF

  associate_public_ip_address = true
}
