class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    torifuda_controller = TorifudaController.alloc.initWithFudaHeight(400, string: 'わかころもてにゆきはふりつつ')
    @window.rootViewController= torifuda_controller

    true
  end
end
