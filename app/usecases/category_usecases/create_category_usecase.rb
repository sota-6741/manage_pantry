module CategoryUsecases
  class CreateCategoryUsecase
    def initialize(user:)
      @user = user
    end

    def call(params)
      category = @user.categories.create!(params)
      category
    end
  end
end
