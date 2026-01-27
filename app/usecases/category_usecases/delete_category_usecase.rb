module CategoryUsecases
  class DeleteCategoryUsecase
    def initialize(category_model: Category)
      @category_model = category_model
    end

    def call(category_id)
      category = @category_model.find(category_id)
      category.destroy!
    end
  end
end
