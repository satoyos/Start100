describe 'TorifudaController' do
  shared 'controller with FudaView' do
    it 'has a fuda_view that is not empty' do
      @controller.instance_eval do
        @fuda_view.should.not.be.nil
      end
    end
  end
  describe 'initialize with string' do
    before do
      @controller = TorifudaController.alloc.initWithFudaHeight(400, string: 'あいみての')
    end

    it 'should be a instance of a UIViewController' do
      @controller.is_a?(UIViewController).should.be.true
    end

    behaves_like 'controller with FudaView'

  end

  describe 'initialize with poem' do
    POEM_INIT_JSON_NO2 =<<'EOF'
{
    "number": 2,
    "poet": "持統天皇",
    "liner": [
    "春過ぎて",
    "夏来にけらし",
    "白妙の",
    "衣干すてふ",
    "天の香具山"
],
    "in_hiragana": {
    "kami": "はるすきてなつきにけらししろたへの",
    "shimo": "ころもほすてふあまのかくやま"
},
    "kimari_ji": "はるす"
}
EOF

    before do
      hash = BW::JSON.parse(POEM_INIT_JSON_NO2)
      @poem = Poem.new(hash)
      @controller = TorifudaController.alloc.initWithFudaHeight(400, poem: @poem)
      @controller.viewDidLoad
    end

    behaves_like 'controller with FudaView'

    it 'should have number of poem' do
      @controller.number.should.be.equal @poem.number
    end

  end

  describe 'handling AudioPlayer' do
    tests TorifudaController

    behaves_like 'controller with FudaView'

    it 'should have an AudioPlayer' do
      self.controller.player.should.not.be.nil
      self.controller.player.is_a?(AVAudioPlayer).should.be.true
    end

    it 'should be able to play the player' do
      self.controller.player.play.should.be.true
    end
  end

  describe 'views' do
    tests TorifudaController

    it 'should hav 15 UILabels' do
      views(UILabel).size.should.be.equal 15
    end

    it 'should have a tatamiView, a FudaView, and a insideView' do
      view(TorifudaController::ACC_LABEL_OF_TATAMI_VIEW).should.not.be.nil
      view(FudaView::ACCESSIBILITY_LABEL).should.not.be.nil
      view(FudaView::ACC_LABEL_OF_INSIDE_VIEW).should.not.be.nil
    end

=begin
    it 'should resize 札View when iPhone get rotated' do

      rotate_device :to => :landscape, :button => :left
      # ↑回転時にNavigationControllerのsetNavigationBarHidden()メソッドを呼ぶので、このテストはムリ！
      fuda_view   = view(FudaView::ACCESSIBILITY_LABEL)
      tatami_view = view(TorifudaController::ACC_LABEL_OF_TATAMI_VIEW)
      inside_view = view(FudaView::ACC_LABEL_OF_INSIDE_VIEW)
      fuda_view.frame.size.height.should.be.close(tatami_view.frame.size.height * controller.fuda_proportion, 1.0)
      fuda_view.frame.size.height.should.be.close(TorifudaController::DEFAULT_HEIGHT, 1.0)
      fuda_view.center.x.should.be.close(inside_view.center.x + inside_view.frame.origin.x, 1.0)
    end
=end
  end

=begin
  describe 'rotation' do
    tests TorifudaController

    it 'should detect device rotation' do
      controller.navigationController.mock!(:setNavigationBarHidden)
      rotate_device :to => :landscape, :button => :left
      1.should == 1
    end
  end
=end
end