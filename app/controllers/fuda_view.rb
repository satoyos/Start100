class FudaView < UIImageView
  # 札のサイズに関するグローバル変数の設定
  INITIAL_FONT_HEIGHT   = 30
  FUDA_SIZE_IN_MM = CGSizeMake(53.0, 73.0)  # 札ビューはこの縦横比になる。

  FONT_SIZE_DIVIDED_BY_POWER = 11 # これに@fuda_powerをかけたものが@font_sizeの値となる。
  OFFSET_DIVIDED_BY_POWER = 2     # これに@fuda_powerをかけたものが@green_offsetの値となる。

  STRING_NOT_SET_MESSAGE = '札の文字はまだ決まっていません'

  # 以下、サイズに関係なく共通するグローバル変数の設定
  $fudaInsideColor = '#FFF7E5'.to_color
  $fontNameHash = {
      hiraminN:   'HiraMinProN-W3',
      timesroman: 'TimesNewRomanPS-ItalicMT',
  }
  $tatami_jpg_file = 'tatami 002.jpg'
  $washi_jpg_file  = 'washi_darkgreen 001.jpg'

  # 札Viewのサイズ(frame.size)を決め、上に載るオブジェクトを積み上げる。
  # 札Viewの位置(frame.origin)にはCGPointZeroを設定する
  def initWithString(string)
    washi_image = UIImage.imageNamed($washi_jpg_file)
    self.initWithImage(washi_image)

    # 札の白台紙ビューを生成して載せる。
    # (ただし、frameにはCGRectZeroを設定し、frame以外の属性は設定しておく)
    @fuda_inside_view = UIView.alloc.initWithFrame(CGRectZero)
    @fuda_inside_view.backgroundColor= $fudaInsideColor
    self.addSubview(@fuda_inside_view)

    # stringの1文字ずつを割り当てた15枚のラベルを生成して載せる。
    # (ラベルについても、サイズの情報は一切設定しない。)
    @labels15 = []
    torifuda_str_array = string.split(//u)
    label_font = UIFont.fontWithName($fontNameHash[:hiraminN], size: INITIAL_FONT_HEIGHT)
    (0..14).each do |idx|
      l = UILabel.alloc.initWithFrame(CGRectZero)
      l.text= torifuda_str_array[idx] || ''
      l.font= label_font
      l.font= label_font
      l.textAlignment= UITextAlignmentCenter
      l.backgroundColor= UIColor.clearColor
      self.addSubview(l)
      @labels15 << l
    end
    self
  end

  # 札Viewのframe.sizeを決めてしまう。
  # また、札Viewに乗っているSubviewsのサイズもこのタイミングで決めてしまう。
  def set_size_by_height(fuda_height)
    # 札Viewのframeを決める(originは未定)
    @height = fuda_height
    @fuda_power  = @height / FUDA_SIZE_IN_MM.height
    width = FUDA_SIZE_IN_MM.width * @fuda_power

    self.frame = [CGPointZero, [width, @height]]

    # 札Viewの子ビューについて、サイズを決定する。
    set_size_of_subviews()
  end

  # 札View自体のサイズが決定した結果を受けて、札Viewの子Viewのサイズも決める。
  def set_size_of_subviews
    # フォントのサイズと札の緑の額縁の幅は、@fuda_powerを元にここで計算している。
    @font_size = @fuda_power * FONT_SIZE_DIVIDED_BY_POWER
    @green_offset = @fuda_power * OFFSET_DIVIDED_BY_POWER

    # 札の白い和紙部分や、その中のラベルのサイズ、フォントのサイズをここで決める。
    set_fuda_inside_view_size()
    set_label_size()
  end

  # 札の白い和紙部分のViewについて、サイズを決定。
  def set_fuda_inside_view_size
    fuda_size = self.frame.size
    @fuda_inside_view.frame = CGRectMake(@green_offset,
                                         @green_offset,
                                         fuda_size.width  - @green_offset * 2,
                                         fuda_size.height - @green_offset * 2)
  end


  # @param [UILabel] label
  def set_label_size
    fuda_size = self.frame.size
    label_size = CGSizeMake((fuda_size.width - @green_offset * 2) / 3,
                            (fuda_size.height - @green_offset * 2) / 5)
    label_origin_zero = CGPoint.new(@green_offset, @green_offset + @font_size * 3 / 10)
    new_font = @labels15.first.font.fontWithSize(@font_size)
    @labels15.each_with_index do |label, idx|
      clmn_idx = case idx
                   when (0..4); 2
                   when (5..9); 1
                   else       ; 0
                 end
      label_origin =
          CGPointMake(label_origin_zero.x + label_size.width * clmn_idx,
                      label_origin_zero.y + label_size.height * (idx % 5))
      #noinspection RubyResolve
      label.frame = [label_origin, label_size]
      #noinspection RubyResolve
      label.font  = new_font

    end
  end
end
