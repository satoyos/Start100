describe 'TorifudaController' do
  before do
    @controller = TorifudaController.alloc.initWithFudaHeight(400, string: 'あいみての')
  end

  it 'should be a instance of a UIViewController' do
    @controller.is_a?(UIViewController).should.be.true
  end

  it 'has a fuda_view that is not empty' do
    @controller.instance_eval do
      @fuda_view.should.not.be.equal nil
    end
  end

  #%Todo: iPhone回転時のテストを書こう！
  describe 'when iPhone rotated' do
    it 'should resize FudaView appropriately'
  end

end