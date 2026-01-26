module Category
  class UpdateCategoryUsecase
    def initialize(category_model: Category)
      @category_model = category_model
    end

    def call(category_id, params)
      category = @category_model.update(category_id, params)
      category
    end
  end
end
