class TorifudaController < UIViewController
  DEFAULT_HEIGHT = 300
  TATAMI_JPG_FILE = 'tatami 002.jpg'

  PROPERTIES = [:fuda_height, :fuda_view, :number, :player]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  def initWithFudaHeight(fuda_height, string: string)
    self.initWithNibName(nil, bundle: nil)
    @fuda_height = fuda_height
    @fuda_view = FudaView.alloc.initWithString(string)
    self
  end

  def initWithFudaHeight(fuda_height, poem: poem)
    self.initWithFudaHeight(fuda_height, string: poem.in_hiragana.shimo)
    @number = poem.number
    base_name = 'audio/%03d' % self.number
    url = NSURL.fileURLWithPath(NSBundle.mainBundle.pathForResource(base_name, ofType: "m4a"))
    er = Pointer.new(:object)
    @player = AVAudioPlayer.alloc.initWithContentsOfURL(url, error: er)

    self

  end

  def viewDidLoad
    super

    # self.viewの上に、self.viewと同じ大きさの畳画像Viewを重ねる。
    set_tatami_view_on_me()

    # 札Viewのframe設定と畳上への描画
    set_fuda_view_on_me()

    @player.play
  end

  # self.viewの上に、self.viewと同じ大きさの畳画像Viewを重ねる。
  def set_tatami_view_on_me
    image = UIImage.imageNamed(TATAMI_JPG_FILE)
    @tatami_view = UIImageView.alloc.initWithImage(image)
    size = self.view.frame.size
    @tatami_view.tap do |tatami|
      tatami.frame = [[0.0, 0.0], size]
      tatami.autoresizingMask=
          UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
      tatami.contentMode= UIViewContentModeScaleAspectFill
      tatami.clipsToBounds= true
    end
    self.view.addSubview(@tatami_view)
  end

  # 札Viewのframe設定と畳上への描画
  def set_fuda_view_on_me
    @fuda_view.set_size_by_height(@fuda_height)
    fuda_size   = @fuda_view.frame.size
    tatami_size = @tatami_view.frame.size
    height_offset = calc_height_offset()
    fuda_origin = CGPointMake(tatami_size.width  / 2 - fuda_size.width  / 2,
                              tatami_size.height / 2 - fuda_size.height / 2 - height_offset / 2)
    @fuda_view.frame= [fuda_origin, fuda_size]
    @tatami_view.addSubview(@fuda_view)
    @fuda_proportion = @fuda_height / (@tatami_view.frame.size.height - height_offset)
    puts '------ 初期状態のサイズ  ------'
    puts_views_data
    puts "heigt_offset => #{height_offset}"
    puts '-----------------------------'
  end

  # 初期状態のself.viewは、画面いっぱいのサイズ。
  # しかし、回転後にリサイズされる時には、navigationBarなどの領域が差し引かれたサイズになる。
  # そこで、初期状態の場合も回転後のサイズと同じサイズになるよう、heightの補正を行う。
  def calc_height_offset
    height_offset = case self.navigationController
                      when nil;
                        0
                      else
                        ; self.navigationController.navigationBar.frame.size.height
                    end
  end


  private :set_tatami_view_on_me, :set_fuda_view_on_me, :calc_height_offset

  # 回転して良いものとする。
  def shouldAutorotate
    true
  end

  # 全方向への回転を許可する。
  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskAll
  end

  def willAnimateRotationToInterfaceOrientation(orientation, duration: duration)
    self.navigationController.setNavigationBarHidden(should_hide_navigation_bar?(orientation),
                                                     animated: true)
    # ↑ これを最初にやっておかないと、中の畳Viewなどのサイズが
    #   NavigationBarを消す前のサイズに設定されてしまう！
    #   必ず最初にやっておくこと！

    prev_orientation = @orientation || UIDeviceOrientationPortrait
    puts "(rotating) orientation: #{prev_orientation} => #{orientation}"
    @orientation = orientation
    new_fuda_height = @tatami_view.frame.size.height * @fuda_proportion
    @fuda_view.set_size_by_height(new_fuda_height)
    @fuda_view.center= @tatami_view.center
    puts '++++ 回転によるサイズ変更 ++++'
    puts_views_data
    puts '++++++++++++++++++++++++++++'
  end

  def should_hide_navigation_bar?(orientation)
    set_navigation_bar_hidden = case orientation
                                  when UIDeviceOrientationPortrait
                                    false
                                  else
                                    true
                                end
  end

  def puts_views_data
    @tatami_view.frame.tap do |f|
      puts "@tatami_view.frame.origin : #{[f.origin.x, f.origin.y]}"
      puts "@tatami_view.frame.size   : #{[f.size.width, f.size.height]}"
    end
    @fuda_view.frame.tap do |f|
      puts "@fuda_view.frame.origin   : #{[f.origin.x, f.origin.y]}"
      puts "@fuda_view.frame.size     : #{[f.size.width, f.size.height]}"
    end
  end

  private :should_hide_navigation_bar?, :puts_views_data
end


__END__




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

