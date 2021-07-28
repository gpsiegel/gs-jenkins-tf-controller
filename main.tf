data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}


resource "aws_instance" "jenkins_instance" {
    #Always using the most recent version of Ubuntu 20.04
    ami = "${data.aws_ami.ubuntu.id}"

    instance_type = "t2.small"


    subnet_id = "${aws_subnet.jenkins_subnet.id}"
    vpc_security_group_ids = ["${aws_security_group.jenkins_sg.id}"]
    #security_group_ids = ["${aws_security_group.jenkins_instance.id}"]
    associate_public_ip_address = true

    # We're assuming there's a key with this name already
    key_name = "build"
/*
    provisioner "local-exec" {
    depends_on = [aws_instance.jenkins_instance]
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ./build.pem -i '${aws_instance.jenkins_instance.public_ip},' playbook.yaml"
  }
*/
}

    #Ansible Command to configure Jenkins on this instance
    provisioner "local-exec" {
      depends_on = [aws_instance.jenkins_instance]
      command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ./build.pem -i '${aws_instance.jenkins_instance.public_ip},' playbook.yaml"
    }
}