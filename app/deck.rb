class Deck
  PROPERTIES = [:poems]
  PROPERTIES.each do |prop|
    attr_accessor prop
  end

  def initialize
    read_poems
  end

  def read_poems
    @poems = []
    @poems << Poem.new
    @poems << Poem.new
  end

  def poems
    @poems
  end
end