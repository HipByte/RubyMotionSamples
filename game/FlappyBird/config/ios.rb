# -*- coding: utf-8 -*-

Motion::Project::App.setup do |app|
  # Use `rake ios:config' to see complete project settings.
  app.name = 'FlappyBird'

  # Portrait mode.
  app.info_plist['UISupportedInterfaceOrientations'] = ['UIInterfaceOrientationPortrait']
end
