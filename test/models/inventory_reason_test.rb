require "test_helper"

class InventoryReasonTest < ActiveSupport::TestCase
  test "初期化: 有効なキーであればインスタンス化できる" do
    reason = InventoryReason.new(:purchase)
    assert_equal :purchase, reason.reason_key
  end

  test "初期化: 無効なキーの場合はArgumentErrorが発生する" do
    assert_raises(ArgumentError) { InventoryReason.new(:invalid_key) }
  end

  test "delta: purchaseの場合は正の値を返す" do
    reason = InventoryReason.new(:purchase)
    assert_equal 10, reason.delta(10)
  end

  test "delta: consumeの場合は負の値を返す" do
    reason = InventoryReason.new(:consume)
    assert_equal -10, reason.delta(10)
  end

  test "delta: disposeの場合は負の値を返す" do
    reason = InventoryReason.new(:dispose)
    assert_equal -5, reason.delta(5)
  end

  test "equality: 同じキーを持つオブジェクトは等価である" do
    reason1 = InventoryReason.new(:purchase)
    reason2 = InventoryReason.new("purchase") # 文字列でもシンボル変換される
    assert_equal reason1, reason2
  end
end
