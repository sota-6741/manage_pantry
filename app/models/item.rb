class Item < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :inventory_logs, dependent: :destroy

  EXPIRED_SOON_DAYS = 3
  MIN_QUANTITY = 0
  MIN_OPERATION_AMOUNT = 1

  # バリデーション
  # nullチェック
  validates :name, presence: true
  validates :quantity, presence: true
  validates :expiration_date, presence: true
  
  validate :name_uniqueness

  # 0以上の数値か？(在庫なしも管理したほうがいいかも)
  validates :quantity, numericality: {
    greater_than_or_equal_to: MIN_QUANTITY
  }

  private

  def name_uniqueness
    return unless user_id

    if Item.where(user_id: user_id, name: name).where.not(id: id).exists?
      errors.add(:base, "「#{name}」はすでに登録されています。")
    end
  end

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

  def apply_inventory_change!(delta)
    raise StandardError, "在庫不足" if quantity + delta < MIN_QUANTITY
    self.quantity += delta
    self
  end

  def update_stock!(delta)
    apply_inventory_change!(delta)
    save!
  end

  class << self
    def ordered_by_urgency
      near_expiration = near_expiration_items
      other = where.not(id: near_expiration.select(:id))
      near_expiration + other
    end

    def near_expiration_items
      where("expiration_date <= ?", Time.zone.today + EXPIRED_SOON_DAYS.days)
        .where("expiration_date >= ?", Time.zone.today)
    end
  end
end
