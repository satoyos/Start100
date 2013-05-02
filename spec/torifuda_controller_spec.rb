describe 'TorifudaController' do
  shared 'controller with FudaView' do
    it 'has a fuda_view that is not empty' do
      @controller.instance_eval do
        @fuda_view.should.not.be.equal nil
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
    POEM_INIT_JSON =<<'EOF'
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
      hash = BW::JSON.parse(POEM_INIT_JSON)
      @poem = Poem.new(hash)
      @controller = TorifudaController.alloc.initWithFudaHeight(400, poem: @poem)
    end

    behaves_like 'controller with FudaView'

    it 'should have number of poem' do
      @controller.number.should.be.equal @poem.number
    end

    it 'should have an AudioPlayer' do
      @controller.player.should.not.be.equal nil
      @controller.player.is_a?(AVAudioPlayer).should.be.true
    end

    it 'should be able to play the player' do
      @controller.player.play.should.be.true
    end
  end

  # 以下、iPhoneの回転がちゃんとテストできるようになってから(rotate_deviceが有効になってから)テストしよう。
=begin
  describe 'when iPhone get rotated' do
    it 'should resize FudaView appropriately' do
      rotate_device :to => :landscape
      @controller.instance_eval do
        @fuda_view.frame.size.height.should.be.close(@tatami_view.frame.size.height * @fuda_proportion, 1.0)
      end
    end
  end
=end

end