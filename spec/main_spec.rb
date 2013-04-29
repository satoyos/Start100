describe "Application 'start100'" do
  before do
    @app = UIApplication.sharedApplication
    @delegate = @app.delegate
  end

  describe 'Application Delegate has a Deck' do
    before do
      @deck = @delegate.deck
    end

    it 'has a Deck' do
      @deck.should.not.be.nil
    end
  end

  describe 'rootViewController(=UINavigationController)' do
    before do
      @controller = @app.keyWindow.rootViewController
    end

    it 'is a UINavigationController' do
      @controller.is_a?(UINavigationController).should.be.true
    end

    it 'has subclass of UITableViewController as a topViewController at 1st' do
      @controller.topViewController.is_a?(UITableViewController).should.be.true
    end

    describe 'tableViewCells on the UITableViewController' do
      before do
        subviews_on_table_view = @controller.topViewController.view.subviews
        @table_view_cells = subviews_on_table_view.select{|view| view.is_a?(UITableViewCell)}
      end
      it 'has some UITableViewCells on the topViewController' do
        (@table_view_cells.size > 0).should.be.true
      end

    end
  end
end
