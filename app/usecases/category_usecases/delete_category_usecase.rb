module CategoryUsecases
  class DeleteCategoryUsecase
    def initialize(category_model: Category)
      @category_model = category_model
    end

    def call(category_id)
      @category_model.destroy(category_id)
    end
  end
end
