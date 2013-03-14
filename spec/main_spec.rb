describe "Application 'start100'" do
  before do
    @app = UIApplication.sharedApplication
  end

  it 'has one controller' do
    controller = @app.keyWindow.rootViewController
    controller.is_a?(TorifudaController).should == true
  end
end
