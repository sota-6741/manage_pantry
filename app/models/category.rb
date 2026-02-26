class Category < ApplicationRecord
  belongs_to :user, optional: true
  has_many :items, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
