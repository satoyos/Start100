class PoemTableController < UITableViewController
  DEFAULT_FONT_SIZE  = 16
  DEFAULT_ROW_HEIGHT = DEFAULT_FONT_SIZE * 4

  attr_reader :deck, :table

  def initWithDeck(deck, fontType: font_type)
    self.initWithNibName(nil, bundle: nil)
    @deck = deck
    @font_type = font_type
    self
  end


  def viewDidLoad
    super

    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    @table.rowHeight= DEFAULT_ROW_HEIGHT
    self.view.addSubview(@table)

    @table.dataSource= self
    @table.delegate= self

  end

  def tableView(tableView, numberOfRowsInSection: section)
    self.deck.poems.size
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= 'CELL_IDENTIFIER'

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) ||
        UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle,
        reuseIdentifier: @reuseIdentifier)
    poem = self.deck.poems[indexPath.row]
    cell.textLabel.text = '%3d. %s %s %s' % [poem.number, poem.liner[0], poem.liner[1], poem.liner[2]]
    cell.detailTextLabel.text = "　　 #{poem.poet}"
    cell.textLabel.font= FontFactory.create_font_with_type(:japaneseW6, size: DEFAULT_FONT_SIZE)
    cell.textLabel.baselineAdjustment= UIBaselineAdjustmentAlignBaselines
=begin
    org_frame = cell.textLabel.frame
    cell.textLabel.frame= [CGPointMake(org_frame.origin.x, org_frame.origin.y+10),
                           [org_frame.size.width, org_frame.size.height-10]]
=end
    cell.detailTextLabel.font = cell.textLabel.font.fontWithSize(DEFAULT_FONT_SIZE-2)
    cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator


    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    alert = UIAlertView.alloc.init
    alert.message= self.deck.poems[indexPath.row].in_hiragana.shimo
    alert.addButtonWithTitle('OK')
    alert.show
  end

end