# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ProMotion"
  s.version = "0.6.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jamon Holmgren", "Silas Matson", "ClearSight Studio"]
  s.date = "2013-05-19"
  s.description = "ProMotion is a new way to easily build RubyMotion iOS apps."
  s.email = ["jamon@clearsightstudio.com", "silas@clearsightstudio.com", "contact@clearsightstudio.com"]
  s.homepage = "https://github.com/clearsightstudio/ProMotion"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "ProMotion is a new way to organize RubyMotion apps. Instead of dealing with UIViewControllers, you work with Screens. Screens are a logical way to think of your app and include a ton of great utilities to make iOS development more like Ruby and less like Objective-C."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
