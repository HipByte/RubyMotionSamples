$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Beers'
  app.frameworks += ['CoreLocation', 'MapKit', 'AddressBook']

  app.info_plist['NSAppTransportSecurity'] = {
    'NSExceptionDomains' => {
      'en.wikipedia.org' => { 'NSTemporaryExceptionAllowsInsecureHTTPLoads' => true }
    }
  }
end
