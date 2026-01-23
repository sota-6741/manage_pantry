require "test_helper"

class InventoryUsecaseTest < ActiveSupport::TestCase
  setup do
    @usecase = InventoryUsecase.new(Item, InventoryLog)
    @item = items(:one)
    @category = categories(:one)
  end

  test "#create_itemは有効なパラメータでItemとInventoryLogを正しく作成する" do
    item_params = {
      name: "新しいアイテム",
      quantity: 10,
      expiration_date: Time.zone.today + 7.days,
      category_id: @category.id
    }

    created_item = nil
    # アイテム
    assert_difference([ "Item.count", "InventoryLog.count" ], 1) do
      created_item = @usecase.create_item(item_params)

      assert_equal "新しいアイテム", created_item.name
      assert_equal 10, created_item.quantity
    end

    # ログ
    assert_not_nil created_item, "アイテムが作成されていません"
    last_log = created_item.inventory_logs.last
    assert_not_nil last_log, "在庫ログが作成されていません"
    assert_equal "purchase", last_log.reason
    assert_equal item_params[:quantity], last_log.change_amount
  end
end
