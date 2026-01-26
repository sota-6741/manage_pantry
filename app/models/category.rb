class Category < ApplicationRecord
  has_many :items

  validates :name, presence: true, uniqueness: true

  class << self
    def register(params)
      create!(params)
    end

    def fetch(id)
      find(id)
    end

    def destroy(id)
      category = fetch(id)
      category.destroy!
    end

    def update(id, params)
      item = fetch(id)
      item.update!(params)
    end

    def all_fetch
      all
    end
  end
end
