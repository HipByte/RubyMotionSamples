# -*- coding: utf-8 -*-

Motion::Project::App.setup do |app|
  # Use `rake android:config' to see complete project settings.
  app.name = 'FlappyBird'

  # Portrait mode.
  app.manifest.child('application').child('activity') do |main_activity|
    main_activity['android:screenOrientation'] = 'portrait'
  end
end
