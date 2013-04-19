describe "Application 'start100'" do
  before do
    @app = UIApplication.sharedApplication
    @delegate = @app.delegate
  end

  it 'has rootViewController of PoemTableController' do
    controller = @app.keyWindow.rootViewController
    controller.is_a?(PoemTableController).should == true
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
