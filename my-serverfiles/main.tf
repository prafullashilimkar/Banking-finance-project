resource "aws_instance" "test-server1" {
  ami           = "ami-02eb7a4783e7e9317" 
  instance_type = "t2.micro" 
  key_name = "jenkinskey1"
  vpc_security_group_ids= ["sg-0fab79b6d1427d7ef"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./jenkinskey1.pem")
    host     = self.public_ip
    
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
    
    
  }
  tags = {
    Name = "test-server1"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.test-server1.public_ip} > inventory "
  }
   provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/Banking-project/my-serverfiles/finance-playbook.yml"
   
  } 
}
