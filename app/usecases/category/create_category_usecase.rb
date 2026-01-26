module Category
  class CreateCategoryUsecase
    def initialize(category_model: Category)
      @category_model = category_model
    end

    def call(params)
      category = @category_model.register(params)
      category
    end
  end
end
