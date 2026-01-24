require "test_helper"

class InventoryLogTest < ActiveSupport::TestCase
  setup do
    @item = items(:one)
  end

  test "バリデーション: 必須項目が欠けている場合は無効" do
    log = InventoryLog.new
    assert_not log.valid?
    assert_includes log.errors[:item], "must exist"
    assert_includes log.errors[:change_amount], "can't be blank"
    assert_includes log.errors[:reason], "can't be blank"
  end

  test "inventory_reason: reasonカラムからInventoryReasonオブジェクトを取得できる" do
    log = InventoryLog.new(reason: "purchase")
    assert_instance_of InventoryReason, log.inventory_reason
    assert_equal :purchase, log.inventory_reason.reason_key
  end

  test "record: ログを保存できる" do
    assert_difference("InventoryLog.count", 1) do
      InventoryLog.record(item: @item, delta: -5, reason_key: :consume)
    end
    
    log = InventoryLog.last
    assert_equal @item, log.item
    assert_equal(-5, log.change_amount)
    assert_equal "consume", log.reason
    assert_equal :consume, log.inventory_reason.reason_key
  end
end
