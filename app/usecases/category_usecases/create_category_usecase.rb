module CategoryUsecases
  class CreateCategoryUsecase
    def initialize(category_model: Category)
      @category_model = category_model
    end

    def call(params)
      category = @category_model.create!(params)
      category
    end
  end
end
