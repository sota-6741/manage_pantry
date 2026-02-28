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
    # 既存のルートが resources :items 内の resources :stock_adjustments になっているか確認
    # ここでは stock_adjustments_controller の担当かもしれない
    # 元々のテストが items_controller_test にあったので、ルーティングに合わせて修正
    # 現在の routes.rb を見ると items の member に stock があり、resources :stock_adjustments もある
    # 以前の controller では change_stock があったかもしれないが、今はなさそうなので修正
    assert_difference("InventoryLog.count", 1) do
      post item_stock_adjustments_url(@item), params: { item: { amount: 3, reason: "consume" } }
    end
    assert_redirected_to items_path
    
    assert_equal "consume", InventoryLog.last.reason
  end
end
