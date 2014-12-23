# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require "motion/project/template/android"

Motion::Project::App.setup do |app|
  app.name = "weather"
  app.permissions = [:internet]
  app.package = "com.willrax.weather"

  app.vendor_project jar: "vendor/volley-1.0.9.jar"
end
