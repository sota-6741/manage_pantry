module CategoryUsecases
  class ListCategoryUsecase
    def initialize(category_model: Category)
      @category_model = category_model
    end

    def call(user:)
      categories = user.categories.all
      categories
    end
  end
end
