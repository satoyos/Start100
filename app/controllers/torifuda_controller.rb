class TorifudaController < UIViewController
  
  # 札のサイズに関するグローバル変数の設定
  $initial_fuda_height = 300
  $fuda_size_in_mm = CGSizeMake(53.0, 73.0)

  # 以下、サイズに関係なく共通するグルー張る変数の設定
  $fudaInsideColor = '#FFF7E5'.to_color
  $fontNameHash = {
      hiraminN:   'HiraMinProN-W3',
      timesroman: 'TimesNewRomanPS-ItalicMT',
  }
  $tatami_jpg_file = 'tatami 002.jpg'
  $washi_jpg_file  = 'washi_darkgreen 001.jpg'

  attr_reader :fuda_height

  def initWithFudaHeight(height)
    self.initWithNibName(nil, bundle: nil)
    @fuda_height = height
    self
  end

  def viewDidLoad
    super

    # 札とその子Viewのサイズを決める「縦サイズ」と「倍率」の初期化
    @fuda_height ||= $initial_fuda_height
    @fuda_power, @fuda_width, @fuda_proportion =
        fuda_power_and_width_by_height(@fuda_height, self.view)
    @font_size, @green_offset = font_size_and_green_offset
    
    # self.viewの上に、self.viewと同じ大きさの畳画像Viewを重ねる。
    image = UIImage.imageNamed($tatami_jpg_file)
    @tatami_view = UIImageView.alloc.initWithImage(image)
    @tatami_view.frame = [[0.0, 0.0], self.view.frame.size]
    @tatami_view.autoresizingMask=
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @tatami_view.contentMode= UIViewContentModeScaleAspectFill
    @tatami_view.clipsToBounds= true
    self.view.addSubview(@tatami_view)

    # self.viewの上に、札View(中身は緑の台紙だけ)
    washi_image = UIImage.imageNamed($washi_jpg_file)
    @fuda_view = UIImageView.alloc.initWithImage(washi_image)
    @fuda_view.frame= fuda_view_frame(@tatami_view)
    @tatami_view.addSubview(@fuda_view)

    # 札Viewの中を描く
    draw_inside_fuda_view(@fuda_view, @green_offset, @font_size)

    slider_test()
  end

  def slider_test
    slider_height = 25
    slider_size = CGSizeMake(@tatami_view.frame.size.width-20, slider_height)
    slider = UISlider.alloc.initWithFrame([[10, @tatami_view.frame.size.height - slider_height],
                                           slider_size])
    #noinspection RailsParamDefResolve
    tapGestureRecognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action: 'slider_tapped:')
    tapGestureRecognizer.numberOfTapsRequired= 2
    slider.addGestureRecognizer(tapGestureRecognizer)

#    slider.continuous= false
    slider.minimumValue= 100
    slider.maximumValue= 900
    slider.value= @fuda_height # 初期値
                               #noinspection RailsParamDefResolve
    slider.addTarget(self, action: 'slider_value_changed:', forControlEvents: UIControlEventValueChanged)

    self.view.addSubview(slider)

    label = UILabel.alloc.initWithFrame(CGRectZero)
    label.text= label_str_of_power()
    label.textAlignment= UITextAlignmentCenter
    label.layer.cornerRadius= 8
    label.backgroundColor= '#AAB3FF'.to_color
    label.sizeToFit
    label_width  = 200
    label_height = label.frame.size.height
    label.frame = CGRectMake((self.view.size.width - label_width) / 2,
                             slider.frame.origin.y - label_height - 10,
                             label_width, label_height)
    @power_label = label
    self.view.addSubview(@power_label)
  end

  def label_str_of_power
    '札のサイズ = %3dx%3d ' % [@fuda_width, @fuda_height]
  end

  def font_size_and_green_offset
    font_size = @fuda_power * 11
    green_offset = @fuda_power * 2

    return font_size, green_offset
  end

  def slider_value_changed(sender)
    set_size_of_fuda_by_height(sender.value, @tatami_view)
  end

  def set_size_of_fuda_by_height(fuda_height, super_view)
    @fuda_height = fuda_height
    @fuda_power, @fuda_width, @fuda_proportion =
        fuda_power_and_width_by_height(fuda_height, super_view)
    @font_size, @green_offset = font_size_and_green_offset

    puts "@fuda_height => #{@fuda_height}"
    @fuda_view.frame= fuda_view_frame(@tatami_view)
    fuda_size = @fuda_view.frame.size
    @fuda_inside_view.frame= fuda_inside_view_frame(fuda_size, @green_offset)
    label_origin, label_size = calc_label_origin_and_size(fuda_size)
    label_origin.each_with_index do |origin, idx|
      new_font = @label15[idx].font.fontWithSize(@font_size)
      #noinspection RubyResolve
      @label15[idx].font = new_font
      #noinspection RubyResolve
      @label15[idx].frame = CGRectMake(origin.x, origin.y,
                                       label_size.width, label_size.height)
    end
    @power_label.text= label_str_of_power
  end

  def fuda_power_and_width_by_height(fuda_height, super_view)
    fuda_power = fuda_height / $fuda_size_in_mm.height
    fuda_width = $fuda_size_in_mm.width * fuda_power
    fuda_proportion = fuda_height / super_view.frame.size.height
    return fuda_power, fuda_width, fuda_proportion
  end

  def draw_inside_fuda_view(fuda_view, green_offset, font_size)
    fuda_size = fuda_view.frame.size
    @fuda_inside_view = UIView.alloc.initWithFrame(fuda_inside_view_frame(fuda_size, green_offset))
    @fuda_inside_view.backgroundColor= $fudaInsideColor
    fuda_view.addSubview(@fuda_inside_view)

    @label15 = []
    label_origin, label_size = calc_label_origin_and_size(fuda_size)

    torifuda_str = 'わかころもてにゆきはふりつつ'
    torifuda_str_array = torifuda_str.split(//u)
    label_font = UIFont.fontWithName($fontNameHash[:hiraminN], size: font_size)
    label_origin.each_with_index do |origin, idx|
      # puts "%2d => %s" % [idx, origin]
      label = UILabel.alloc.initWithFrame([origin, label_size])
      label.text= torifuda_str_array[idx] || ''
      label.font= label_font
      label.textAlignment= UITextAlignmentCenter
      label.backgroundColor= UIColor.clearColor
      fuda_view.addSubview(label)
      @label15 << label
    end
  end

  def calc_label_origin_and_size(fuda_size)
    label_size = CGSizeMake((fuda_size.width - @green_offset * 2) / 3,
                            (fuda_size.height - @green_offset * 2) / 5)
    label_origin_zero = CGPoint.new(@green_offset, @green_offset + @font_size * 3 / 10)
    label_origin = []
    (0..14).each do |label_idx|
      clmn_idx = case label_idx
                   when (0..4); 2
                   when (5..9); 1
                   else       ; 0
                 end
      label_origin[label_idx] =
          CGPointMake(label_origin_zero.x + label_size.width * clmn_idx,
                      label_origin_zero.y + label_size.height * (label_idx % 5))
    end
    return label_origin, label_size
  end

  def fuda_view_frame(tatami_view)
    fuda_size = CGSizeMake($fuda_size_in_mm.width  * @fuda_power,
                           $fuda_size_in_mm.height * @fuda_power)
    fuda_origin = CGPointMake(tatami_view.frame.size.width / 2 - fuda_size.width / 2,
                              tatami_view.frame.size.height / 2 - fuda_size.height / 2)
    [fuda_origin, fuda_size]
  end

  def fuda_inside_view_frame(fuda_size, offset)
    CGRectMake(offset, offset,
               fuda_size.width - offset * 2, fuda_size.height - offset * 2)
  end

  THUMB_WIDTH = 11

  def slider_tapped(gesture_recognizer)
    if gesture_recognizer.state == UIGestureRecognizerStateEnded
      slider = gesture_recognizer.view
      x = gesture_recognizer.locationInView(slider).x
      puts "x = #{x}"
      slider_min_x = slider.frame.origin.x + THUMB_WIDTH
      slider_max_x = slider.frame.origin.x + slider.frame.size.width - THUMB_WIDTH
      x = slider_min_x if x < slider_min_x
      x = slider_max_x if x > slider_max_x
      slider_min_val = slider.minimumValue
      slider_max_val = slider.maximumValue

      slider.value = slider_min_val + (x - slider_min_x) / (slider_max_x - slider_min_x) * (slider_max_val - slider_min_val)

      set_size_of_fuda_by_height(slider.value, @tatami_view)
    end

  end

  # 回転して良いものとする。
  def shouldAutorotate
    true
  end

  # 全方向への回転を許可する。
  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskAll
  end

  def willAnimateRotationToInterfaceOrientation(orientation, duration: duration)
    frame_size = self.view.frame.size
    prev_orientation = @orientation || UIDeviceOrientationPortrait
    puts "(rotating) frame_size => [#{frame_size.width}, #{frame_size.height}]"
    puts "(rotating) 現在のorientation => #{prev_orientation}"
    puts "(rotating) 新しいorientation => #{orientation}"
    @orientation = orientation
    new_fuda_height = case orientation
                        when UIInterfaceOrientationLandscapeLeft, UIInterfaceOrientationLandscapeRight
                          frame_size.width  * @fuda_proportion
                        else
                          frame_size.height * @fuda_proportion
                      end
    set_size_of_fuda_by_height(new_fuda_height, @tatami_view)
  end
end


__END__

    puts '++++++++++++++++'
    puts "@tatami_view.frame.origin => #{[@tatami_view.frame.origin.x, @tatami_view.frame.origin.y]}"
    puts "@tatami_view.frame.size   => #{[@tatami_view.frame.size.width, @tatami_view.frame.size.height]}"
    puts "inside_view.frame.origin => #{[@fuda_inside_view.frame.origin.x, @fuda_inside_view.frame.origin.y]}"
    puts "inside_view.frame.size   => #{[@fuda_inside_view.frame.size.width, @fuda_inside_view.frame.size.height]}"
    puts "@fuda_view.frame.origin   => #{[@fuda_view.frame.origin.x, @fuda_view.frame.origin.y]}"
    puts "@fuda_view.frame.size     => #{[@fuda_view.frame.size.width, @fuda_view.frame.size.height]}"
    puts '++++++++++++++++'

前回のコミットからの機能修正
 - 畳の描画位置が下にずれていた問題に対応した。
