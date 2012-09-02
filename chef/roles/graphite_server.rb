name "graphite_server"
description "construct a graphite server"

run_list [
          "recipe[graphite]"
         ]

override_attributes(
                    :graphite => {
                      :carbon => {
                        :line_receiver_interface => "0.0.0.0"
                      }
                    }
                   )
