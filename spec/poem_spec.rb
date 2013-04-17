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

describe Poem do
  describe 'initialize' do
    before do
      @hash = BW::JSON.parse(POEM_INIT_JSON)
      @poem = Poem.new(@hash)
    end

    it 'should be initialized by Hash data' do
      @hash.is_a?(Hash).should == true
    end
    it 'should not be nil' do
      @poem.should.not == nil
    end
    it 'should have"持統天皇" as poet' do
      @poem.poet.should == '持統天皇'
    end
    it 'should have liner data that consists of 5 parts' do
      @poem.liner.size.should == 5
    end
    it 'should have 決まり字「はるす」' do
      @poem.kimari_ji.should == 'はるす'
    end

  end
end