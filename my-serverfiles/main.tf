resource "aws_instance" "test-server" {
  ami           = "ami-02eb7a4783e7e9317" 
  instance_type = "t2.micro" 
  key_name = "jenkinskey1"
  vpc_security_group_ids= ["sg-0fab79b6d1427d7ef"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./jenkinskey1.pem")
    #host     = self.public_ip
    host      = aws_instance.test-server.public_dns
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
     ansiblePlaybook credentialsId: '3.110.29.35', installation: 'ansible', inventory: 'finance-playbook.yml', playbook: '/var/lib/jenkins/workspace/Banking-project/my-serverfiles/', vaultCredentialsId: 'AWS_ACCESS_KEY_ID'
  } 
}
