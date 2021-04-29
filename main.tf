resource "aws_instance" "webserver" {
  ami                    = "ami-01e7ca2ef94a0ae86" # Ubuntu
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.websg.id]

  user_data = <<-EOF
        #!/bin/bash
        echo "Hello World" > index.html
        nohup busybox httpd -f -p 80 &
        EOF
  tags = {
    "Name" = "webserver-mandeep"
  }
}

output "webserveripaddress" {
  value = aws_instance.webserver.public_ip
}

resource "aws_security_group" "websg" {
  name = "webserversg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}