class Poem
  PROPERTIES = [:number, :poet]
  PROPERTIES.each do |prop|
    attr_accessor prop
  end

  def initialize

  end
end