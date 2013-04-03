class Poem
  PROPERTIES = [:number, :poet]
  PROPERTIES.each do |prop|
    attr_accessor prop
  end

  def initialize(attributes = {})
    attributes.each do  |key, value|
      self.send("#{key}=", value) if PROPERTIES.member? key.to_sym
    end
  end
end