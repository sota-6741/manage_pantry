require "test_helper"

class ItemTest < ActiveSupport::TestCase
  setup do
    @category = categories(:one)
    @item = items(:one)
    @item.update!(quantity: 10.0) # テストのために数量を整数値に設定
  end

  test "update_stock!: 在庫を更新して保存する" do
    @item.update_stock!(5)
    assert_equal 15, @item.quantity
    assert_equal 15, @item.reload.quantity
  end

  test "update_stock!: 在庫が負になる場合はエラーが発生し、保存されない" do
    # 現在10なので -11 すると -1
    assert_raises(StandardError, "在庫不足") do
      @item.update_stock!(-11)
    end
    
    assert_equal 10, @item.reload.quantity
  end

  test "register: アイテムを作成して保存する" do
    params = {
      name: "New Item",
      quantity: 5,
      expiration_date: Date.today,
      category_id: @category.id
    }
    
    item = nil
    assert_difference("Item.count", 1) do
      item = Item.register(params)
    end
    
    assert_equal "New Item", item.name
    assert_equal 5, item.quantity
    assert item.persisted?
  end

  test "fetch: IDでアイテムを取得する" do
    found_item = Item.fetch(@item.id)
    assert_equal @item, found_item
  end
end
