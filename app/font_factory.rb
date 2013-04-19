FONT_TYPE_HASH = {
    japanese: 'HiraMinProN-W3'
}


class FontFactory
  def self.create_font_with_type(font_type, size: size)
    UIFont.fontWithName(FONT_TYPE_HASH[font_type], size: size)
  end

end