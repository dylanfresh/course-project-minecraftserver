output "public_ip" {
  value = aws_instance.minecraft.public_ip
}

output "instance_id" {
  value = aws_instance.minecraft.id
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/minecraft_key ubuntu@${aws_instance.minecraft.public_ip}"
}
