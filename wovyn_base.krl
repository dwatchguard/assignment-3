ruleset wovyn_base {
  meta {
    shares __testing
  }
  global {
    temperature_threshold = 77;
  }

 rule process_heartbeat {
    select when wovyn heartbeat
    send_directive("wovyn", "Heartbeat Received");
  }
 rule find_high_temps {
    select when wovyn new_temperature_reading
    pre {
    violation = event:attr("temperature") > temperature_threshold;
    }
    send_directive("violation", violation)
    fired {
        raise wovyn event "threshold_violation" attributes event:attrs if violation;
    }
  }
 rule threshold_notification {
    select when wovyn threshold_violation
    send_directive("yep", "WE REACHED THIS")
 } 
}
