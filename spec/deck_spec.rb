describe 'Deck' do
  describe 'initialize without path' do

    before do
      @deck = Deck.new
    end

    describe 'has some Poems' do
      before do
        @poems = @deck.poems
      end
      it 'is not empty deck' do
        @poems.should.not == nil
        @poems.size.should > 0
      end
      it 'has a Poem of No.1 "秋の田の"' do
        first_poem = @poems[1]
        first_poem.number.should == 1
        #noinspection RubyResolve
        first_poem.poet.should == '天智天皇'
      end
    end
  end

  JSON_FILE = 'poems.json'

  describe 'initialize with path' do
    before do
      @poems = Deck.new.poems
    end

    it 'has array of poem object' do
      @poems.is_a?(Array).should == true
    end
    it 'has a Poem of No.0 by "unknown"' do
      first_poem = @poems[0]
      first_poem.number.should == 0
      #noinspection RubyResolve
      first_poem.poet.should == 'unknown'
    end

    it 'has a Poem of No.1 by "天智天皇"' do
      first_poem = @poems[1]
      first_poem.number.should == 1
      #noinspection RubyResolve
      first_poem.poet.should == '天智天皇'
    end

    it 'has a Poem of No.2 by "持統天皇"' do
      first_poem = @poems[2]
      first_poem.number.should == 2
      #noinspection RubyResolve
      first_poem.poet.should == '持統天皇'
    end
  end
end


__END__

