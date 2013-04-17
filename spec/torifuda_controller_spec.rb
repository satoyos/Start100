describe 'TorifudaController' do
  before do
    @controller = TorifudaController.alloc.initWithFudaHeight(400, string: 'あいみての')
  end

  it 'should be a instance of a UINavigationController' do
    @controller.is_a?(UINavigationController).should == true
  end

  it 'has a fuda_view that is not empty' do
    @controller.instance_eval do
      @fuda_view.should.not == nil
    end
  end


end