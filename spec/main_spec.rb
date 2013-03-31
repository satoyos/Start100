describe "Application 'start100'" do
  before do
    @app = UIApplication.sharedApplication
    @delegate = @app.delegate
  end

  it 'has one controller' do
    controller = @app.keyWindow.rootViewController
    controller.is_a?(TorifudaController).should == true
  end

  describe 'Application Delegate has a Deck' do
    before do
      @deck = @delegate.deck
    end

    it 'has a Deck' do
      @deck.should.not == nil
    end


  end
end
