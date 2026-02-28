require "test_helper"

class InventoryLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @item = items(:one)
  end

  test "アイテムの履歴一覧を表示できる" do
    # 履歴を1つ作成
    InventoryLog.record(item: @item, delta: 5, reason_key: :purchase)

    get item_inventory_logs_url(@item)
    assert_response :success
    assert_match "購入", response.body
  end

  test "存在しないアイテムの履歴は見られない" do
    get item_inventory_logs_url(item_id: 99999)
    assert_redirected_to items_path
    assert_equal "アイテムが見つかりません", flash[:alert]
  end

  test "他人のアイテムの履歴は見られない" do
    other_item = items(:two)
    get item_inventory_logs_url(other_item)
    assert_redirected_to items_path
    assert_equal "アイテムが見つかりません", flash[:alert]
  end
end
