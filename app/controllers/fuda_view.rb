class FudaView < UIImageView
  # 札のサイズに関する定数の設定
  INITIAL_FONT_HEIGHT   = 30
  FUDA_SIZE_IN_MM = CGSizeMake(53.0, 73.0)  # 札ビューはこの縦横比になる。

  FONT_SIZE_DIVIDED_BY_POWER = 11 # これに@fuda_powerをかけたものが@font_sizeの値となる。
  OFFSET_DIVIDED_BY_POWER = 2     # これに@fuda_powerをかけたものが@green_offsetの値となる。

  # サイズ以外の定数の設定
  INSIDE_COLOR = '#FFF7E5'.to_color
  FONT_NAME_HASH = {
      hiraminN:   'HiraMinProN-W3',
      timesroman: 'TimesNewRomanPS-ItalicMT',
  }
  WASHI_JPG_FILE  = 'washi_darkgreen 001.jpg'
  STRING_NOT_SET_MESSAGE = '札の文字はまだ決まっていません'
  ACCESSIBILITY_LABEL = 'fuda_view'
  ACC_LABEL_OF_INSIDE_VIEW = 'inside_view'

  # 札Viewのサイズ(frame.size)を決め、上に載るオブジェクトを積み上げる。
  # 札Viewの位置(frame.origin)にはCGPointZeroを設定する
  def initWithString(string)
    self.accessibilityLabel= ACCESSIBILITY_LABEL
    create_green_frame_on_me()
    create_background_view_on_me()
    create_labels_on_me(string)
    self
  end

  # 札Viewのframe.sizeを決めてしまう。
  # また、札Viewに乗っているSubviewsのサイズもこのタイミングで決めてしまう。
  def set_size_by_height(fuda_height)
    # 札Viewのframeを決める(originは未定)
    @height = fuda_height
    @fuda_power  = fuda_height / FUDA_SIZE_IN_MM.height
    width = FUDA_SIZE_IN_MM.width * @fuda_power

    self.frame = [CGPointZero, [width, fuda_height]]

    # 札Viewの子ビューについて、サイズを決定する。
    set_size_of_subviews()
  end

  # 以下、プライベートな定義
  private

  # 緑和紙の「額縁」を生成して載せる。
  def create_green_frame_on_me
    washi_image = UIImage.imageNamed(WASHI_JPG_FILE)
    self.initWithImage(washi_image)
  end

  # 札の白台紙ビューを生成して載せる。
  # (ただし、frameにはCGRectZeroを設定し、frame以外の属性は設定しておく)
  def create_background_view_on_me
    @fuda_inside_view = UIView.alloc.initWithFrame(CGRectZero)
    @fuda_inside_view.tap do |i_view|
      i_view.backgroundColor= INSIDE_COLOR
      i_view.accessibilityLabel= ACC_LABEL_OF_INSIDE_VIEW
    end
    self.addSubview(@fuda_inside_view)
  end

  # stringの1文字ずつを割り当てた15枚のラベルを生成して載せる。
  # (ラベルについても、サイズの情報は一切設定しない。)
  def create_labels_on_me(string)
    @labels15 = []
    torifuda_str_array = string.split(//u)
    label_font = FontFactory.create_font_with_type(:japanese, size: INITIAL_FONT_HEIGHT)
    (0..14).each do |idx|
      label = UILabel.alloc.initWithFrame(CGRectZero)
      label.tap do |l|
        l.text= torifuda_str_array[idx] || ''
        l.font= label_font
        l.textAlignment= UITextAlignmentCenter
        l.backgroundColor= UIColor.clearColor
      end
      self.addSubview(label)
      @labels15 << label
    end
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

  def set_label_size
    fuda_size = self.frame.size
    label_size = CGSizeMake((fuda_size.width - @green_offset * 2) / 3,
                            (fuda_size.height - @green_offset * 2) / 5)
    label_origin_zero = CGPoint.new(@green_offset, @green_offset + @font_size * 2 / 10)
    # 和風フォントで上下方向のセンタリングがうまく機能しないので、補正。 ^^^^^^^^^^^^^^^^^^^^^
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
      label.frame = [label_origin, label_size]
      label.font  = new_font

    end
  end
end
