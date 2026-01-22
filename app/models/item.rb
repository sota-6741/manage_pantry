class Item < ApplicationRecord
  belongs_to :category
  has_many :inventory_logs, dependent: :destroy

  EXPIRED_SOON_DAYS = 3
  MIN_QUANTITY = 0
  MIN_OPERATION_AMOUNT = 1

  # バリデーション
  # nullチェック
  validates :name, presence: true
  validates :quantity, presence: true
  validates :expiration_date, presence: true
  # 0以上の数値か？(在庫なしも管理したほうがいいかも)
  validates :quantity, numericality: {
    greater_than_or_equal_to: MIN_QUANTITY
  }

  # ビジネスロジック
  def expired?
    # 期限切れ判定
    expiration_date < Time.zone.today
  end

  def expired_soon?
    # 今日から3日以内に期限切れ
    !expired? && expiration_date <= Time.zone.today + EXPIRED_SOON_DAYS.days
  end

  def consume(amount)
    # 在庫の消費
    update_quantity(amount, :consume)
  end

  def dispose(amount)
    # 在庫の破棄
    update_quantity(amount, :dispose)
  end

  def purchase(amount)
    # 在庫の追加
    update_quantity(amount, :purchase)
  end


  private
  def update_quantity(amount, reason)
    # 在庫数の更新
    return add_error("数量は数値で入力してください") unless amount.is_a?(Numeric)
    return add_error("数量は0より大きい数値を入力してください") if amount <= MIN_OPERATION_AMOUNT - 1

    difference = case reason.to_sym
    when :purchase
      amount
    when :consume, :dispose
      -amount
    else
      raise ArgumentError, "不明な理由: #{reason}"
    end

    # 在庫の不足チェック
    return add_error("在庫が不足しています") if (quantity + difference) < MIN_QUANTITY

    # 値の更新
    update!(quantity: quantity + difference)
    # inventory_logsの作成
    inventory_logs.create!(
      change_amount: difference,
      reason: reason
    )

    true
  rescue ActiveRecord::RecordInvalid => e
    add_error(e.message)
    false
  end

  def add_error(message)
    errors.add(:base, message)
    false
  end
end
