class Item < ApplicationRecord
  belongs_to :category
  has_many :inventory_logs, dependent: :destroy

  # バリデーション
  # nullチェック
  validates :name, presence: true
  validates :quantity, presence: true
  validates :expiration_date, presence: true
  # 0以上の数値か？
  validates :quantity, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  # ビジネスロジック
  def expired?
    # 期限切れ判定
    expiration_date < Date.today
  end

  def expired_soon?
    # 今日から3日以内に期限切れ
    !expired? && expiration_date <= Date.today + 3.days
  end

  def consume(amount)
    # 在庫の消費
    update_quantity(-amount, :consume)
  end

  def dispose(amount)
    # 在庫の破棄
    update_quantity(-amount, :dispose)
  end

  def purchase(amount)
    # 在庫の追加
    update_quantity(amount, :purchase)
  end


  private
  def update_quantity(amount, reason)
    # 在庫数の更新
    raise ArgumentError, "数量は0以上の数値" if amount <= 0

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

    update!(quantity: quantity + difference)
    # TODO: 在庫変更の履歴を作成する
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
