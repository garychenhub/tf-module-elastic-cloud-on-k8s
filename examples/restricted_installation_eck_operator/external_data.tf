data "external" "home_directory" {
  program = ["sh", "-c", "echo '{\"home\":\"'$HOME'\"}'"]
}

