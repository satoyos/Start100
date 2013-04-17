describe 'Deck' do
  describe 'initialize' do
    before do
      @poems = Deck.new.poems
    end

    it 'should be an array of poem object' do
      @poems.is_a?(Array).should == true
      @poems[0].is_a?(Poem).should == true
    end

    it 'should have 100 element' do
      @poems.size.should == 100
    end

    it 'has first Poem that is No.1 and made by "天智天皇"' do
      first_poem = @poems[0]
      first_poem.number.should == 1
      #noinspection RubyResolve
      first_poem.poet.should == '天智天皇'
      first_poem.liner[1].should == 'かりほの庵の'
    end

    it 'has 2nd Poem that is No.2 and made by "持統天皇"' do
      second_poem = @poems[1]
      second_poem.number.should == 2
      #noinspection RubyResolve
      second_poem.poet.should == '持統天皇'
      second_poem.in_hiragana.shimo.should == 'ころもほすてふあまのかくやま'
    end
  end
end


__END__

