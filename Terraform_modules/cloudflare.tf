# resource "cloudflare_record" "console-paas" {
#   zone_id = ""
#   name    = "CNAME from alb"
#   value   = "${aws_lb.alb.dns_name}"
#   type    = "CNAME"
#   proxied = true
# }
