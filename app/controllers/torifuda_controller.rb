class TorifudaController < UIViewController
  DEFAULT_HEIGHT = 300
  TATAMI_JPG_FILE = 'tatami 002.jpg'

  def initWithFudaHeight(fuda_height, string: string)
    self.initWithNibName(nil, bundle: nil)
    @fuda_height = fuda_height
    @fuda_view = FudaView.alloc.initWithString(string)
    self
  end

  def viewDidLoad
    super

    # self.viewの上に、self.viewと同じ大きさの畳画像Viewを重ねる。
    set_tatami_view_on_me()

    # 札Viewのframe設定と畳上への描画
    set_fuda_view_on_me()

    # sliderをここで設置していたときの名残
    # slider_test()
  end

  # self.viewの上に、self.viewと同じ大きさの畳画像Viewを重ねる。
  def set_tatami_view_on_me
    image = UIImage.imageNamed(TATAMI_JPG_FILE)
    @tatami_view = UIImageView.alloc.initWithImage(image)
    size = self.view.frame.size

    @tatami_view.frame = [[0.0, 0.0], size]
    @tatami_view.autoresizingMask=
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @tatami_view.contentMode= UIViewContentModeScaleAspectFill
    @tatami_view.clipsToBounds= true
    self.view.addSubview(@tatami_view)
  end

  # 札Viewのframe設定と畳上への描画
  def set_fuda_view_on_me
    @fuda_view.set_size_by_height(@fuda_height)
    fuda_size = @fuda_view.frame.size
    height_offset = 0
    if self.navigationController
      height_offset = self.navigationController.navigationBar.frame.size.height / 2
    end
    fuda_origin = CGPointMake(@tatami_view.frame.size.width / 2 - fuda_size.width / 2,
                              @tatami_view.frame.size.height / 2 - fuda_size.height / 2 - height_offset)
    @fuda_view.frame= [fuda_origin, fuda_size]
    @tatami_view.addSubview(@fuda_view)
    @fuda_proportion = @fuda_height / @tatami_view.frame.size.height
  end

  private :set_tatami_view_on_me, :set_fuda_view_on_me

  # 回転して良いものとする。
  def shouldAutorotate
#    true
    false
  end

  # 全方向への回転を許可する。
  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskAll
  end

  # @param [Fixnum] orientation
  # @param [Fixnum] duration
  # @return []
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
    @fuda_view.set_size_by_height(new_fuda_height)
    @fuda_view.center= @tatami_view.center
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
    slider.value= @fuda_view.frame.size.height # 初期値
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

  def slider_value_changed(sender)
    set_size_by_height(sender.value)
    @power_label.text= label_str_of_power
  end

  def label_str_of_power
    size = @fuda_view.frame.size
    '札のサイズ = %3dx%3d ' % [size.width, size.height]
  end


  def calc_fuda_proportion
    fuda_proportion = @fuda_view.frame.size.height / self.view.frame.size.height
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

      set_size_by_height(slider.value, @tatami_view)
    end

  end

