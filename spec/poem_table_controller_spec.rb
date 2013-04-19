describe PoemTableController do
  describe 'initialize' do
    before do
      @poem_table_controller = PoemTableController.alloc.initWithDeck(Deck.new)
      @deck = @poem_table_controller.deck
    end

    it 'should not be nil' do
      @poem_table_controller.should.not == nil
    end

    it 'should have a deck' do
      @deck.should.not == nil
      @deck.is_a?(Deck).should == true
    end

    it 'should be a dataSource of itself' do
      @poem_table_controller.viewDidLoad
      @poem_table_controller.table.dataSource.is_a?(PoemTableController).should == true
    end
  end

  describe '2 important methods for UITableViewController' do
    before do
      @poem_table_controller = PoemTableController.alloc.initWithDeck(Deck.new)
      @poem_table_controller.viewDidLoad
    end

    it 'should support tableView:numOfRowsInSection:' do
      number = @poem_table_controller.tableView(@poem_table_controller.table,
                                                 numberOfRowsInSection: nil)
      number.should.not == nil
      number.should == 100
    end

    it 'should support tableView:cellForRowAtIndexPath:' do
      indexPath = NSIndexPath.indexPathForRow(0, inSection: 0)
      cell = @poem_table_controller.tableView(@poem_table_controller.table,
                                              cellForRowAtIndexPath: indexPath)
      cell.should.not == nil
      cell.is_a?(UITableViewCell).should == true
    end
  end

end