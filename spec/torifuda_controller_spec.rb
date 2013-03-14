describe 'TorifudaController' do
  describe 'initWithFudaHeight' do
    before {@object = TorifudaController.alloc.initWithFudaHeight(400)}
    it 'should not be nil' do
      @object.should.not == nil
    end
  end
end