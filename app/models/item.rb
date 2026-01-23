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

  # 状態管理メソッド
  def expired?
    # 期限切れ判定
    expiration_date < Time.zone.today
  end

  def expired_soon?
    # 今日から3日以内に期限切れ
    !expired? && expiration_date <= Time.zone.today + EXPIRED_SOON_DAYS.days
  end

  def has_stock?
    quantity.positive?
  end

  def can_change_quantity?(delta)
    (quantity + delta) >= MIN_QUANTITY
  end
end
