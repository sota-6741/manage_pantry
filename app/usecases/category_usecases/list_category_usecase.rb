module CategoryUsecases
  class ListCategoryUsecase
    def initialize(category_model: Category)
      @category_model = category_model
    end

    def call
      categories = @category_model.all_fetch
      categories
    end
  end
end
