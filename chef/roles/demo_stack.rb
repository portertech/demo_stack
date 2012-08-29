name "demo_stack"
description "demo stack application"

run_list [
          "recipe[riak]",
          "recipe[demo_stack::gdash]"
         ]
