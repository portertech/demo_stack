# Demo Stack

A demo for a Polyglot Vancouver presentation on application monitoring.

## Abstract

Monitoring is important, as you can't manage what you haven't
measured. Rule of thumb; if it moves graph it, if it's critical alert
on it (actionable). Know what your application is doing, and know when
it fails. There are several ways an application can emit and expose
the data that we as developers and operators care about, the most
common methods being log streams and instrumentation. Logs can be a
treasure trove of information, usually *lightly structured, full of
metrics, performance and usage indicators. Manual instrumentation is a
necessary evil, providing a way to measure what code does when it
runs, in production. Knowing application dependencies, understanding
their relationships, and monitoring all the way down to the system
resources they consume is a MUST. Nothing beats a functional
check. There is not one tool to rule them all, think unix toolchain;
Logstash, Collectd, Sensu, Graphite, and Gdash. Visibility is
important, dashboards are *good as people can recognize *patterns.

Demo.

## License

Copyright (C) 2012 Sean Porter Consulting

Distributed under the Eclipse Public License, the same as Clojure.
