resource "aws_instance" "test-server" {
  ami           = "ami-02eb7a4783e7e9317" 
  instance_type = "t2.micro" 
  key_name = "jenkinskey1"
  vpc_security_group_ids= ["sg-0fab79b6d1427d7ef"]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("./jenkinskey1.pem")
    host     = self.public_ip
    
  }
  provisioner "remote-exec" {
    #inline = [ "echo 'wait to start instance' "]
    inline = [ "sudo hostnamectl set-hostname cloudEc2.technix.com"]
    
  }
  tags = {
    Name = "test-server"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.test-server.public_ip} > inventory "
  }
   provisioner "local-exec" {
  #command = "ansible-playbook /var/lib/jenkins/workspace/Banking-project/my-serverfiles/finance-playbook.yml"
   command =  "ansiblePlaybook credentialsId: 'test-server1', disableHostKeyChecking: true, installation: 'ansible', inventory: '/etc/ansible/hosts', playbook: 'ansible-playbook.yml' "
  } 
}
