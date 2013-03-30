describe 'FudaView' do
  SHIMO_STR = 'おきまどわせるしらきくのはな'
  INITIAL_HEIGHT = 400
  before {
    @controller = TorifudaController.alloc.initWithFudaHeight(INITIAL_HEIGHT, string: SHIMO_STR)
    @fuda_view = @controller.instance_variable_get('@fuda_view')
    puts "fuda_view before test => #{@fuda_view.to_s}"
  }
  describe 'initWithString' do
    it 'it should not be nil' do
      @fuda_view.should.not == nil
    end
    it 'has labels created from SHIMO_STR ' do
      puts "fuda_view in 1st method test => #{@fuda_view.to_s}"
      @fuda_view.instance_eval do
        @labels15.size.should == 15
        idx = Random.new.rand(0..14)
        puts "random number => [#{idx}]"
        @labels15[idx].text.should == SHIMO_STR[idx]
      end
    end
  end
  describe 'set_size_by_height' do

    before do
      # 一度札Viewの高さをINITIAL_HEIGHTに設定しておき、その時の諸々のサイズを取得しておく。
      @fuda_view.set_size_by_height(INITIAL_HEIGHT)
      puts "fuda_view in 2nd method test => #{@fuda_view.to_s}"
      puts "fuda_view_height in 2nd method test => #{@fuda_view.frame.size.height}"
      @fuda_view.instance_eval do
        @org_inside_view_size = @fuda_inside_view.frame.size
        @org_label_size = @labels15.first.frame.size
      end

      # その後、札Viewの高さをINITIAL_HEIGHTの半分に再設定。
      @fuda_view.set_size_by_height(INITIAL_HEIGHT/2)

    end
    it 'should have half size frame' do
      @fuda_view.frame.size.height.should.close?(INITIAL_HEIGHT/2, 1.0)
    end
    it 'should have subViews of half size' do

      @fuda_view.instance_eval do
        @fuda_inside_view.frame.size.height.should.close?(@org_inside_view_size.height/2, 1.0)
        @labels15.first.frame.size.height.should.close?(@org_label_size.height/2, 1.0)
      end
     end
  end
end
