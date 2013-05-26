class TorifudaController < UIViewController
  DEFAULT_HEIGHT = 300
  TATAMI_JPG_FILE = 'tatami 002.jpg'

  PROPERTIES = [:fuda_height, :fuda_view, :number, :player, :fuda_proportion]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  VIEW_FRAME_DEBUG = false

  # テストで呼び出す際のデフォルトデータ
  DEFAULT_POEM_NUMBER = 2
  DEFAULT_SHIMO = 'ころもほすてふあまのかくやま'
  ACC_LABEL_OF_TATAMI_VIEW = 'tatami_view'

  def initWithFudaHeight(fuda_height, string: string)
    self.initWithNibName(nil, bundle: nil)
    @fuda_height = fuda_height
    @fuda_view = FudaView.alloc.initWithString(string)
    self
  end

  def initWithFudaHeight(fuda_height, poem: poem)
    self.initWithFudaHeight(fuda_height, string: poem.in_hiragana.shimo)
    @number = poem.number

    self

  end

  def viewDidLoad
    super
    prepare_unit_test()
    set_tatami_view_on_me()
    set_fuda_view_on_tatami()
    set_audio_player_and_play()
  end

  def prepare_unit_test
    unless @fuda_height
      @number = DEFAULT_POEM_NUMBER
      self.initWithFudaHeight(DEFAULT_HEIGHT, string: DEFAULT_SHIMO)
    end
  end

  def set_audio_player_and_play
    @player = AudioPlayerFactory.create_player_by_path(yomi_basename,
                                                       ofType: 'm4a')
    @player.delegate = self
    @player.play
  end

  def yomi_basename
    'audio/%03d' % self.number
  end

  # self.viewの上に、self.viewと同じ大きさの畳画像Viewを重ねる。
  def set_tatami_view_on_me
    @tatami_view = UIImageView.alloc.initWithImage(UIImage.imageNamed(TATAMI_JPG_FILE))
    @tatami_view.tap do |tatami|
      tatami.frame = [[0.0, 0.0], size_of_view]
      tatami.autoresizingMask=
          UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
      tatami.contentMode= UIViewContentModeScaleAspectFill
      tatami.clipsToBounds= true
      tatami.accessibilityLabel= ACC_LABEL_OF_TATAMI_VIEW
      self.view.addSubview(tatami)
    end
  end

  def size_of_view
    self.view.frame.size
  end

  # 札Viewのframe設定と畳上への描画
  def set_fuda_view_on_tatami
    @fuda_view.set_all_sizes_by(@fuda_height)
    fuda_origin = CGPointMake(tatami_size.width  / 2 - fuda_size.width  / 2,
                              tatami_size.height / 2 - fuda_size.height / 2 - height_offset / 2)
    @fuda_view.frame= [fuda_origin, fuda_size]
    @tatami_view.addSubview(@fuda_view)
    @fuda_proportion = @fuda_height / (tatami_size.height - height_offset)
    debug_puts_initial_size(height_offset) if VIEW_FRAME_DEBUG
  end

  def fuda_size
    @fuda_view.frame.size
  end
  private :fuda_size

  def tatami_size
    @tatami_view.frame.size
  end
  private :tatami_size
  
  def debug_puts_initial_size(height_offset)
    puts '------ 初期状態のサイズ  ------'
    puts_views_data
    puts "height_offset => #{height_offset}"
    puts '-----------------------------'
  end


  # 初期状態のself.viewは、画面いっぱいのサイズ。
  # しかし、回転後にリサイズされる時には、navigationBarなどの領域が差し引かれたサイズになる。
  # そこで、初期状態の場合も回転後のサイズと同じサイズになるよう、heightの補正を行う。
  def height_offset
    height_offset = case self.navigationController
                      when nil;
                        0
                      else
                        ; self.navigationController.navigationBar.frame.size.height
                    end
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

  private :set_tatami_view_on_me, :set_fuda_view_on_tatami, :height_offset
  private :debug_puts_initial_size, :should_hide_navigation_bar?, :puts_views_data

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
    @fuda_view.set_all_sizes_by(new_fuda_height)
    @fuda_view.center= @tatami_view.center
    debug_puts_on_rotation() if VIEW_FRAME_DEBUG
  end
  
  def new_fuda_height
    @tatami_view.frame.size.height * @fuda_proportion
  end
  

  def debug_puts_on_rotation
    puts '++++ 回転によるサイズ変更 ++++'
    puts_views_data
    puts '++++++++++++++++++++++++++++'
  end
  private :debug_puts_on_rotation

end
