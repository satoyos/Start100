describe 'FontFactory' do
  describe 'create_font_with_type' do
    describe 'when type is :japanese' do
      before do
        @font = FontFactory.create_font_with_type(:japanese, size: 10)
      end

      it 'should not be nil' do
        @font.should.not == nil
      end

      it 'should be a UIFont' do
        @font.is_a?(UIFont) == true
      end
    end

    #%ToDo: 次は、サポートしていないfont_typeで初期化しようとした場合を実装！
    # → この時は、システムデフォルトフォントを指定して返す
  end
end