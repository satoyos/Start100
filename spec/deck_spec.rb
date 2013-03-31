describe 'Deck' do
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
      first_poem.poet == '天智天皇'
    end
  end
end


__END__

