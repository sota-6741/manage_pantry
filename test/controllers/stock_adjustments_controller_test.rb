require "test_helper"

class StockAdjustmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @item = items(:one)
  end

  test "在庫調整フォームを表示できる" do
    get new_item_stock_adjustment_url(@item)
    assert_response :success
  end

  test "在庫を増やせる（購入）" do
    assert_difference("InventoryLog.count", 1) do
      post item_stock_adjustments_url(@item), params: {
        stock_adjustment: { amount: 5, reason: "purchase" }
      }
    end
    assert_equal 15, @item.reload.quantity # フィクスチャで10に設定されている
    assert_equal "purchase", InventoryLog.last.reason
  end

  test "在庫を減らせる（消費）" do
    assert_difference("InventoryLog.count", 1) do
      post item_stock_adjustments_url(@item), params: {
        stock_adjustment: { amount: 3, reason: "consume" }
      }
    end
    assert_equal 7, @item.reload.quantity # 10 - 3 = 7
    assert_equal "consume", InventoryLog.last.reason
  end

  test "バリデーションエラー時はエラーメッセージを返す" do
    assert_no_difference("InventoryLog.count") do
      post item_stock_adjustments_url(@item), params: {
        stock_adjustment: { amount: 0, reason: "consume" }
      }
    end
    # Controller は HTML の場合は redirect_to items_path になっている
    assert_redirected_to items_path
    assert_not_nil flash[:alert]
  end

  test "他人のアイテムの在庫調整はできない" do
    other_item = items(:two) # user: two のアイテム
    post item_stock_adjustments_url(other_item), params: {
      stock_adjustment: { amount: 1, reason: "consume" }
    }
    assert_response :not_found
  end
end
