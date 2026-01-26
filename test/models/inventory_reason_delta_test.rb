require "test_helper"

class InventoryReasonDeltaTest < ActiveSupport::TestCase
  test "初期化: 有効なキーであればインスタンス化できる" do
    reason = InventoryReasonDelta.new(:purchase)
    assert_equal :purchase, reason.reason_key
  end

  test "初期化: 無効なキーの場合はArgumentErrorが発生する" do
    assert_raises(ArgumentError) { InventoryReasonDelta.new(:invalid_key) }
  end

  test "delta: purchaseの場合は正の値を返す" do
    reason = InventoryReasonDelta.new(:purchase)
    assert_equal 10, reason.delta(10)
  end

  test "delta: consumeの場合は負の値を返す" do
    reason = InventoryReasonDelta.new(:consume)
    assert_equal -10, reason.delta(10)
  end

  test "delta: disposeの場合は負の値を返す" do
    reason = InventoryReasonDelta.new(:dispose)
    assert_equal -5, reason.delta(5)
  end

  test "equality: 同じキーを持つオブジェクトは等価である" do
    reason1 = InventoryReasonDelta.new(:purchase)
    reason2 = InventoryReasonDelta.new("purchase") # 文字列でもシンボル変換される
    assert_equal reason1, reason2
  end
end
