require "test_helper"

class InventoryUsecaseTest < ActiveSupport::TestCase
  setup do
    @create_item_usecase = Inventory::CreateItemUsecase.new(item_model: Item, inventory_log_model: InventoryLog)
    @change_stock_usecase = Inventory::ChangeStockUsecase.new(item_model: Item, inventory_log_model: InventoryLog)
    @item = items(:one)
    @category = categories(:one)
  end

  test "CreateItemUsecase#call は有効なパラメータでItemとInventoryLogを正しく作成する" do
    item_params = {
      name: "新しいアイテム",
      quantity: 10,
      expiration_date: Time.zone.today + 7.days,
      category_id: @category.id
    }

    created_item = nil
    # アイテム
    assert_difference([ "Item.count", "InventoryLog.count" ], 1) do
      created_item = @create_item_usecase.call(item_params)

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

  test "ChangeStockUsecase#call は在庫を更新しログを作成する" do
    amount = 5
    reason_key = :consume

    # 初期在庫を確認
    initial_quantity = @item.quantity

    updated_item = nil
    assert_difference("InventoryLog.count", 1) do
      updated_item = @change_stock_usecase.call(
        item_id: @item.id,
        amount: amount,
        reason_key: reason_key
      )
    end

    # 在庫の変化を確認
    expected_quantity = initial_quantity - amount # consume なので減る
    assert_equal expected_quantity, updated_item.quantity
    assert_equal expected_quantity, updated_item.reload.quantity

    # ログの確認
    last_log = InventoryLog.last
    assert_equal @item.id, last_log.item_id
    assert_equal(-amount, last_log.change_amount) # consume なので負の値
    assert_equal "consume", last_log.reason
  end
end
