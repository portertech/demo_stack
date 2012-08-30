name "demo_stack"
description "demo stack application"

run_list [
          "recipe[demo_stack]",
          "recipe[demo_stack::gdash]"
         ]
