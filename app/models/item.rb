class Item < ApplicationRecord
  belongs_to :category
  has_many :InventoryLogs, dependent: :destroy

  # バリデーション
  # nullチェック
  validates :name, presence: true
  validates :quantity, presence: true
  validates :expiration_date, presence: true

  # 0以上の数値である
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
    # TODO: 在庫を減らす(privateメソッドで共通処理として実装したほうが良さそう)
    # TODO: 履歴を作る(inventory_logsのメソッドを呼び出す)
  end

  def purchase(amount)
    # 在庫の追加
    # TODO: 在庫を増やす(privateメソッドで共通処理として実装したほうが良さそう)
    # TODO: 履歴を作る(inventory_logsのメソッドを呼び出す)
  end
end
