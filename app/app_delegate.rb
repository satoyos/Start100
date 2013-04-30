class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

#    torifuda_controller = TorifudaController.alloc.initWithFudaHeight(400, string: 'わかころもてにゆきはふりつつ')
    @deck = Deck.new
    poem_table_controller = PoemTableController.alloc.initWithDeck(@deck, fontType: :japanese)
    @window.rootViewController= UINavigationController.alloc.initWithRootViewController(poem_table_controller)



    true

  end

  def deck
    @deck
  end
end

class UINavigationController
  def shouldAutorotate
    self.visibleViewController.shouldAutorotate
  end

  def supportedInterfaceOrientations
    self.visibleViewController.supportedInterfaceOrientations
  end
end