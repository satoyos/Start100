class PoemTableController < UITableViewController

  attr_reader :deck, :table

  def initWithDeck(deck)
    self.initWithNibName(nil, bundle: nil)
    @deck = deck

    self
  end

  def viewDidLoad
    super

    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    @table.autoresizingMask= UIViewAutoresizingFlexibleHeight
    self.view.addSubview(@table)

    @table.dataSource= self

  end

  def tableView(tableView, numberOfRowsInSection: section)
    self.deck.poems.size
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= 'CELL_IDENTIFIER'

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) ||
        UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault,
        reuseIdentifier: @reuseIdentifier)
    poem = self.deck.poems[indexPath.row]
    cell.textLabel.text = '%3d %s %s' % [poem.number, poem.liner[0], poem.liner[1]]
    cell
  end

end