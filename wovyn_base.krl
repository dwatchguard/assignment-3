ruleset wovyn_base {
  meta {
    shares __testing
  }
  global {
    temperature_threshold = 77;
  }

 rule process_heartbeat {
    select when wovyn heartbeat
    send_directive("wovyn", {"body" : "Heartbeat Received"});
    fired {
        raise wovyn event "new_temperature_reading" attributes { "temperature": event:attr("genericThing").get("data", "temperature", "temperatureF"), "timestamp": time:now()};
    }
  }
 rule find_high_temps {
    select when wovyn new_temperature_reading
    pre {
    violation = event:attr("temperature") > temperature_threshold;
    }
    send_directive("violation", {"vio": violation});
    fired {
        raise wovyn event "threshold_violation" attributes event:attrs if violation;
    }
  }
 rule threshold_notification {
    select when wovyn threshold_violation
    send_directive("YEP", {"YES" : "WE REACHED THIS"});
 } 
}
