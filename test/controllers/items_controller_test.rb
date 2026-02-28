require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @item = items(:one)
    @category = categories(:one)
  end

  test "アイテムを作成できる" do
    assert_difference(["Item.count", "InventoryLog.count"], 1) do
      post items_url, params: { item: { name: "New Item", quantity: 5, expiration_date: "2026-12-31", category_id: @category.id } }
    end
    assert_redirected_to items_path
    assert_equal "purchase", InventoryLog.last.reason
  end

  test "在庫を変更できる" do
    assert_difference("InventoryLog.count", 1) do
      post item_stock_adjustments_url(@item), params: { stock_adjustment: { amount: 3, reason: "consume" } }
    end
    assert_redirected_to items_path
    
    assert_equal "consume", InventoryLog.last.reason
  end
end
