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
    self.poems=[]
    BW::JSON.parse(File.read(json_path_bw)).each do |poem_hash|
      self.poems << Poem.new(poem_hash)
    end
  end

  def json_path_bw
    BW::App.resources_path().stringByAppendingPathComponent JSON_FILE
  end
end