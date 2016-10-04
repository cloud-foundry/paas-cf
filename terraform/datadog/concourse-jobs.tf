resource "datadog_timeboard" "concourse-jobs" {

  title = "${format("%s job runtime difference", var.env) }"
  description = "vs previous hour"
  read_only = false

  graph {
    title = "Runtime changes vs hour ago"
    viz = "change"
    request {
       q = "${format("avg:concourse.build.finished{bosh-deployment:%s} by {job}", var.env)}"
    }
  }
}
