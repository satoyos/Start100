# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bubble-wrap'
require 'motion-stump'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'start100'
  app.frameworks += ['AVFoundation', 'AudioToolbox']

  app.codesign_certificate = 'iPhone Developer: Yoshifumi Sato'

  app.identifier = 'com.satoyos.Start_100'

  app.provisioning_profile = '/Users/yoshi/Library/MobileDevice/Provisioning/My_Provisioning_for_Test_App_on_iPhone5.mobileprovision'

  app.icons = ['tori-icon.png', 'tori-icon@2x.png']
  app.prerendered_icon = true
end
