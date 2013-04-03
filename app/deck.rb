class Deck
  PROPERTIES = [:poems]
  PROPERTIES.each do |prop|
    attr_accessor prop
  end

  JSON_FILE = 'poems.json'

  def initialize
    read_poems
  end

  def read_poems
    @poems = []
    new_path = BW::App.resources_path().stringByAppendingPathComponent JSON_FILE
    str = File.read(new_path)
    poem_hashes = BW::JSON.parse(str)
    poem_hashes.each do |hash|
      @poems << Poem.new(hash)
    end
  end


  def poems
    @poems
  end
end