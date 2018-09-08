variable "server_port" {
	default = 8080
}
output "elb_dns_name" {
  value = "${aws_elb.example.dns_name}"
}


provider "aws" {
  access_key = "${var.aws_access_key}"
	  secret_key = "${var.aws_secret_key}"
		region = "${var.aws_region}"}


data "aws_availability_zones" "all" {}


resource "aws_launch_configuration" "app01-aws-US-east-1" {
	image_id = "ami-2d39803a"
	instance_type = "t2.micro"
	security_groups = ["${aws_security_group.instance.id}"]
	user_data = <<-EOF
	#!/bin/bash
	echo "Hello, World" > index.html
	nohup busybox httpd -f -p "${var.server_port}" &
	EOF
	lifecycle {
		create_before_destroy = true
	}

}

resource "aws_security_group" "instance" {
	name = "web_server"

	tags {
		Name = "web_server"
	}
	ingress {
		from_port = "${var.server_port}"
		to_port = "${var.server_port}"
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	lifecycle {
		create_before_destroy = true
	}

}

resource "aws_autoscaling_group" "example" {
	launch_configuration = "${aws_launch_configuration.app01-aws-US-east-1.id}"
	
	availability_zones = ["${data.aws_availability_zones.all.names}"]
	min_size = 5
	max_size = 10
	# add instance to ELB 	
	load_balancers = ["${aws_elb.example.name}"]
  # Use elb for health check and restart if unhealthy
	health_check_type = "ELB"

	tag {
		key = "Name"
		value = "terraform-asg-example"
		propagate_at_launch = true
	}
}


# Create ELB 
resource "aws_elb" "example" {
  name = "terraform-asg-example"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
	# use ELB security group
	security_groups = ["${aws_security_group.elb.id}"]
	
	# health check every 30 seconds mark as healthy
	  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.server_port}/"
  }


	# Listen on port 80 and route them to instance port opened by instance security group
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }
}

# Need to create a security group for ELB to allow incoming on port 80
resource "aws_security_group" "elb" {
  name = "terraform-elb"
  # ingress = inbound
	ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
	# egress = outbound. Allow for health check of instances
	 egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

