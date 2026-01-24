class DeleteItemUsecase
  def initialize(item: Item)
    @item = item # item_model から item に変更
  end

  def call(item_id)
    item = @item.find(item_id)
    item.destroy! # destory! から destroy! に変更
  end
end
