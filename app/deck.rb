class Deck
  PROPERTIES = [:poems]
  PROPERTIES.each do |prop|
    attr_accessor prop
  end

  JSON_FILE = '100.json'

  def initialize
    read_poems
  end

  def read_poems
    new_path = BW::App.resources_path().stringByAppendingPathComponent JSON_FILE
    str = File.read(new_path)
    self.poems=[]
    BW::JSON.parse(str).each do |poem_hash|
      self.poems << Poem.new(poem_hash)
    end

  end
end