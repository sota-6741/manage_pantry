class Item < ApplicationRecord
  belongs_to :category
  has_many :inventory_logs, dependent: :destroy

  # バリデーション
  # nullチェック
  validates :name, presence: true
  validates :quantity, presence: true
  validates :expiration_date, presence: true
  # 0以上の数値か？(在庫なしも管理したほうがいいかも)
  validates :quantity, numericality: {
    greater_than_or_equal_to: 0
  }

  # ビジネスロジック
  def expired?
    # 期限切れ判定
    expiration_date < Time.zone.today
  end

  def expired_soon?
    # 今日から3日以内に期限切れ
    !expired? && expiration_date <= Time.zone.today + 3.days
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
    raise ArgumentError, "数量は0より大きい数値を入力してください" if amount <= 0

    difference = case reason.to_sym
    when :purchase
      amount
    when :consume, :dispose
      -amount
    else
      raise ArgumentError, "不明な理由: #{reason}"
    end

    # 在庫の不足チェック
    return false if (quantity + difference) < 0

    # 値の更新
    update!(quantity: quantity + difference)
    # inventory_logsの作成
    inventory_logs.create!(
      change_amount: difference,
      reason: reason
    )

    true
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end
end
