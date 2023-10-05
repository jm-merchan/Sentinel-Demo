policy "restrict-ec2-type" {
  source            = "./restrict-ec2-type.sentinel"
  enforcement_level = "soft-mandatory"
}
policy "restrict_SG_0000" {
  source            = "./restrict-sg.sentinel"
  enforcement_level = "hard-mandatory"
}