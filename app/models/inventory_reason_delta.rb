class InventoryReasonDelta
  attr_reader :reason_key

  # 理由と符号（係数）の定義を一元管理
  CONFIG = {
    purchase: 1,
    consume: -1,
    dispose: -1
  }.freeze

  # 外部から有効な理由一覧を参照できるようにする
  VALID_REASONS = CONFIG.keys.freeze

  def initialize(reason_key)
    @reason_key = reason_key.to_sym
    raise ArgumentError, "Invalid reason: #{@reason_key}" unless CONFIG.key?(@reason_key)
  end

  def delta(amount)
    CONFIG[@reason_key] * amount
  end

  def to_s
    @reason_key.to_s
  end

  def to_sym
    @reason_key
  end

  def ==(other)
    other.is_a?(self.class) && reason_key == other.reason_key
  end
end
