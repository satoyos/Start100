describe PoemTableController do
  describe 'initialize' do
    before do
      @poem_table_controller = PoemTableController.alloc.initWithDeck(Deck.new, fontType: :japanese)
      @deck = @poem_table_controller.deck
    end

    it 'should not be nil' do
      @poem_table_controller.should.not.be.equal nil
    end

    it 'should have a deck' do
      @deck.should.not.be.equal nil
      @deck.is_a?(Deck).should.be.true
    end

    it 'should have title [PoemTableController::DEFAULT_TITLE]' do
      @poem_table_controller.title.should.be.equal PoemTableController::DEFAULT_TITLE
    end

    it 'should be a dataSource of itself' do
      @poem_table_controller.viewDidLoad
      @poem_table_controller.table.dataSource.is_a?(PoemTableController).should.be.true
    end
  end

  describe '2 important methods for UITableViewController' do
    before do
      @accessoryType = UITableViewCellAccessoryDisclosureIndicator
      @poem_table_controller = PoemTableController.alloc.initWithDeck(Deck.new, fontType: :japanese)
      @poem_table_controller.viewDidLoad
    end

    it 'should support tableView:numOfRowsInSection:' do
      number = @poem_table_controller.tableView(@poem_table_controller.table,
                                                 numberOfRowsInSection: nil)
      number.should.not.be.equal nil
      number.should.be.equal 100
    end

    it 'should support tableView:cellForRowAtIndexPath:' do
      indexPath = NSIndexPath.indexPathForRow(0, inSection: 0)
      cell = @poem_table_controller.tableView(@poem_table_controller.table,
                                              cellForRowAtIndexPath: indexPath)
      cell.should.not == nil
      cell.is_a?(UITableViewCell).should.be.true
      cell.textLabel.font.fontName.should.be.equal FontFactory::FONT_TYPE_HASH[:japaneseW6]
      cell.detailTextLabel.text.include?('天智天皇').should.be.true
      cell.accessoryType.should.be.equal UITableViewCellAccessoryDisclosureIndicator
      cell.accessibilityLabel.should.match /poem[0-9][0-9][0-9]/
    end


  end

  # 下記のテストは、画面遷移を伴うタップのテストが書けるようになるまで封印。(T_T)
=begin
  describe 'when a poem is tapped' do
    before do
      @poem_table_controller = PoemTableController.alloc.initWithDeck(Deck.new, fontType: :japanese)
      @poem_table_controller.viewDidLoad
    end

    it 'must happens that TorifudaController comes over' do
      @poem_table_controller.tap('poem002')
      nav_controller = @poem_table_controller.navigationController
      nav_controller.topViewController.is_a?(TorifudaController).should.be.false
    end
  end
=end


end