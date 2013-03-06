class TorifudaController < UIViewController
  $fudaInsideColor = '#FFF7E5'.to_color
  $fontNameHash = {
      hiramin:    'HiraMinProN-W3',
      timesroman: 'TimesNewRomanPS-ItalicMT',
  }
  $greenOffset = 10
  def viewDidLoad
    super

    @fuda_power = 5

    image = UIImage.imageNamed('tatami 001.jpg')
    tatami_view = UIImageView.alloc.initWithImage(image)
    tatami_view.frame = self.view.frame
    tatami_view.center = self.view.center
    self.view.addSubview(tatami_view)

#    return



    fuda_size = CGSizeMake(53.0 * @fuda_power, 73.0 * @fuda_power)
    fuda_origin = CGPointMake(tatami_view.frame.size.width / 2 - fuda_size.width / 2,
                              tatami_view.frame.size.height / 2 - fuda_size.height / 2)
    washi_image = UIImage.imageNamed('washi_darkgreen 001.jpg')
    fuda_view = UIImageView.alloc.initWithImage(washi_image)
    fuda_view.frame= [fuda_origin, fuda_size]
    self.view.addSubview(fuda_view)

    green_offset = $greenOffset
    fuda_inside_view = UIView.alloc.initWithFrame([
        [green_offset, green_offset],
        [fuda_size.width - green_offset * 2, fuda_size.height - green_offset * 2]])
    fuda_inside_view.backgroundColor= $fudaInsideColor
    fuda_view.addSubview(fuda_inside_view)

    puts '++++++++++++++++'
    puts "tatami_view.frame.origin => #{[tatami_view.frame.origin.x, tatami_view.frame.origin.y]}"
    puts "tatami_view.frame.size   => #{[tatami_view.frame.size.width, tatami_view.frame.size.height]}"
    puts "inside_view.frame.origin => #{[fuda_inside_view.frame.origin.x, fuda_inside_view.frame.origin.y]}"
    puts "inside_view.frame.size   => #{[fuda_inside_view.frame.size.width, fuda_inside_view.frame.size.height]}"
    puts "fuda_view.frame.origin   => #{[fuda_view.frame.origin.x, fuda_view.frame.origin.y]}"
    puts "fuda_view.frame.size     => #{[fuda_view.frame.size.width, fuda_view.frame.size.height]}"
    puts '++++++++++++++++'

    label_size = CGSizeMake((fuda_size.width  - green_offset * 2) / 3,
                            (fuda_size.height - green_offset * 2) / 5)
    label_origin_zero = CGPoint.new(green_offset, green_offset*2)
    label_origin = []
    (0..14).each do |label_idx|
      clmn_idx = case label_idx
                   when (0..4)
                     2
                   when (5..9)
                     1
                   else
                     0
                 end
      label_origin[label_idx] = [label_origin_zero.x + label_size.width * clmn_idx,
                                 label_origin_zero.y + label_size.height * (label_idx % 5)]
    end
    torifuda_str = 'わかころもてにゆきはふりつつ'
    torifuda_str_array = torifuda_str.split(//u)
    label_font = UIFont.fontWithName($fontNameHash[:hiramin], size: 42)
    label_origin.each_with_index do |origin, idx|
      # puts "%2d => %s" % [idx, origin]
      label = UILabel.alloc.initWithFrame([origin, label_size])
      label.text= torifuda_str_array[idx] || ''
      label.font= label_font
      label.textAlignment= UITextAlignmentCenter
      label.backgroundColor= UIColor.clearColor
      fuda_view.addSubview(label)
    end
  end
end