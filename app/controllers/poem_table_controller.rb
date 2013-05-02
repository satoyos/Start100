class PoemTableController < UITableViewController
  DEFAULT_FONT_SIZE  = 16
  DEFAULT_ROW_HEIGHT = DEFAULT_FONT_SIZE * 4
  DEFAULT_TITLE = '取り札を見る'

  attr_reader :deck, :table, :tapped

  def initWithDeck(deck, fontType: font_type)
    self.initWithNibName(nil, bundle: nil)
    @deck = deck
    @font_type = font_type
    self.title= DEFAULT_TITLE
    self
  end

  def viewDidLoad
    super

    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    @table.rowHeight= DEFAULT_ROW_HEIGHT
    self.view.addSubview(@table)

    @table.dataSource= self
    @table.delegate= self
    @tapped = false

  end

  def tableView(tableView, numberOfRowsInSection: section)
    unless self.deck
      initWithDeck(Deck.new, fontType: :japanese)
    end
    self.deck.poems.size
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= 'CELL_IDENTIFIER'

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) ||
        UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle,
        reuseIdentifier: @reuseIdentifier)

    cell.contentView.subviews.each do |subview|
      subview.removeFromSuperview
    end

    poem = self.deck.poems[indexPath.row]
    cell.tap do |c|
      c.textLabel.text = '%3d. %s %s %s' % [poem.number, poem.liner[0], poem.liner[1], poem.liner[2]]
      c.detailTextLabel.text = "　　 #{poem.poet}"
      c.textLabel.font= FontFactory.create_font_with_type(:japaneseW6, size: DEFAULT_FONT_SIZE)
      c.detailTextLabel.font = c.textLabel.font.fontWithSize(DEFAULT_FONT_SIZE-2)
      c.accessoryType= UITableViewCellAccessoryDisclosureIndicator
      c.accessibilityLabel= Poem::DEFAULT_LABEL_PATTERN % poem.number
    end

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    @tapped = true
    poem = self.deck.poems[indexPath.row]
    torifuda_controller = TorifudaController.alloc.initWithFudaHeight(TorifudaController::DEFAULT_HEIGHT,
                                                                      poem: poem)
    self.navigationController.pushViewController(torifuda_controller, animated: true)
  end

  def shouldAutorotate
    false
  end

  # 回転させようとしたが、回転前のView?が残ってしまい、綺麗に回転させられなかった。
  def willAnimateRotationToInterfaceOrientation(orientation, duration: duration)
    puts 'PoemTableControllerで回転を検出しました。'
    @table.reloadData
  end


end