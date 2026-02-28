require "test_helper"

class ItemTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
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

  test "create: ユーザーを指定してアイテムを作成できる" do
    item = Item.new(
      name: "New Item",
      quantity: 5,
      expiration_date: Date.today,
      category: @category,
      user: @user
    )
    
    assert item.save
    assert_equal "New Item", item.name
    assert_equal 5, item.quantity
    assert_equal @user, item.user
  end

  test "ordered_by_urgency: 期限順にソートされる" do
    # items(:one) は 2026-01-19
    # 新しく作成して順序を確認
    Item.create!(name: "Past", quantity: 1, expiration_date: 1.day.ago, user: @user)
    Item.create!(name: "Future", quantity: 1, expiration_date: 10.days.from_now, user: @user)
    
    items = Item.ordered_by_urgency
    assert items.first.expiration_date < items.last.expiration_date
  end
end
