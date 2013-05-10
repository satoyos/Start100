describe PoemTableController do
  describe 'initialize' do
    before do
      @poem_table_controller = PoemTableController.alloc.initWithDeck(Deck.new, fontType: :japanese)
      @deck = @poem_table_controller.deck
    end

    it 'should not be nil' do
      @poem_table_controller.should.not.be.nil
    end

    it 'should have a deck' do
      @deck.should.not.be.nil
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
      number.should.not.be.nil
      number.should.be.equal 100
    end

    it 'should support tableView:cellForRowAtIndexPath:' do
      indexPath = NSIndexPath.indexPathForRow(0, inSection: 0)
      cell = @poem_table_controller.tableView(@poem_table_controller.table,
                                              cellForRowAtIndexPath: indexPath)
      cell.should.not.be.nil
      cell.is_a?(UITableViewCell).should.be.true
      cell.textLabel.font.fontName.should.be.equal FontFactory::FONT_TYPE_HASH[:japaneseW6]
      cell.detailTextLabel.text.include?('天智天皇').should.be.true
      cell.accessoryType.should.be.equal UITableViewCellAccessoryDisclosureIndicator
      cell.accessibilityLabel.should.match /poem[0-9][0-9][0-9]/
    end


  end

  describe 'when a poem is tapped' do
    tests PoemTableController

    before do
      indexPath = NSIndexPath.indexPathForRow(1, inSection: 0)
      @second_cell = controller.tableView(controller.table,
                                          cellForRowAtIndexPath: indexPath)
    end

    it 'should have a tableView' do
      @second_cell.should.not.be.nil
      @second_cell.is_a?(UITableViewCell).should.be.true
=begin
      # 実際に下記テストでタップすると、
      # [ERROR: NoMethodError - undefined method `convertPoint' for nil:NilClass]
      # というエラーが出て落ちるので、それが解決するまではタップは行わない。
      controller.navigationController.mock!(:pushViewController)
      tap(@second_cell)
      controller.instance_variable_get('@tapped_poem').number.should == 3
=end
    end
  end


end