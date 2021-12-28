# resource "cloudflare_record" "console-paas" {
#   zone_id = "61de978f47e2d4be9667310317141de8"
#   name    = "CNAME from alb"
#   value   = "${aws_lb.alb.dns_name}"
#   type    = "CNAME"
#   proxied = true
# }