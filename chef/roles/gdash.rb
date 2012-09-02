name "gdash"
description "gdash graphite dashboard"

run_list [
          "recipe[gdash]",
          "recipe[gdash::base_dashboard]",
          "recipe[gdash::graph_generator]"
         ]

