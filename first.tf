provider "aws"{
	access_key="AKIAZTIMJ7JHPVODYVZA"
	secret_key="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"
	region="eu-west-1"
}

resource  "aws_instance" "A04terraform2"{
	ami="ami-00b49e2d0e1fc7fad"
	instance_type="t2.medium"
   	key_name="${aws_key_pair.abarnykey2.id}"
        tags={
          Name="train0412"
        }
	vpc_security_group_ids=["${aws_security_group.abarnysecgroup2.id}"]
	provisioner "local-exec"{
  	when="create"
	command="echo ${aws_instance.A04terraform2.public_ip}>opfile.txt"
	}
        provisioner "chef"{
        connection{
 	     host="${self.public_ip}"
	     type="rdb"
	     user="Administrator"
	     private_key="${file("C:\\train\\secondkey.pem")}"

        }
	run_list = ["testenv_aws_tf_chef::default"]
	recreate_client= true
        node_name="traino4node"
        server_url="https://manage.chef.io/organizations/traino4"
	user_name="traino4"
	user_key="${file("C:\\train\\chef-starter\\chef-repo\\.chef\\train4.pem")}"
	ssl_verify_mode=":verify_none"
   
       }

}
resource "aws_security_group" "abarnysecgroup2"{
	name="abarnysecgroup2"
	description="to allow"
	ingress{
	   from_port="0"
	   to_port="0"
	   protocol="-1"
	   cidr_blocks=["0.0.0.0/0"]
	}
	egress{
	   from_port="0"
	   to_port="0"
	   protocol="-1"
	   cidr_blocks=["0.0.0.0/0"]
	}
}
resource "aws_key_pair" "abarnykey2"{
	key_name="abarnykeypair2"
	public_key ="${file("C:\\train\\publickey.pub")}"

}
output "abycip"{
	value="${aws_instance.A04terraform2.public_ip}"
}
resource "aws_eip" "A04terraform2"{
	tags={
	Name="abarnyeip"
	}
	instance="${aws_instance.A04terraform2.id}"
}

resource "aws_s3_bucket" "abarnybucket"{
	bucket="abarnybucket"	
	acl="private"
	force_destroy="true"
}
terraform{
backend "s3"{
 bucket ="abarnybucket"
 key="terraform.tfstate"
 region="eu-west-1"
}
}
