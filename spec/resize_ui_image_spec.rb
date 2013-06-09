describe 'ResizeUIImage' do
  NEW_SIZE = CGSizeMake(60, 20)
  before do
    @image = UIImage.imageNamed(TorifudaController::VOLUME_BUTTON_PNG_FILE)
    @new_image = ResizeUIImage.resizeImage(@image, newSize: NEW_SIZE)
  end

  it 'should return UIImage object' do
    @new_image.should.not.be.nil
    @new_image.should.is_a?(UIImage)
    @new_image.size.should == NEW_SIZE
  end

end