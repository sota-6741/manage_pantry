require "test_helper"

class CategoryUsecaseTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @create_usecase = CategoryUsecases::CreateCategoryUsecase.new(user: @user)
    @list_usecase = CategoryUsecases::ListCategoryUsecase.new
    @update_usecase = CategoryUsecases::UpdateCategoryUsecase.new
    @delete_usecase = CategoryUsecases::DeleteCategoryUsecase.new
    @category = categories(:one)
  end

  test "CreateCategoryUsecase#call は有効なパラメータでCategoryを作成する" do
    params = { name: "New Category" }

    assert_difference("Category.count", 1) do
      created_category = @create_usecase.call(params)
      assert_equal "New Category", created_category.name
      assert_equal @user, created_category.user
    end
  end

  test "ListCategoryUsecase#call はユーザーのカテゴリー一覧を取得する" do
    categories = @list_usecase.call(user: @user)
    assert_includes categories, @category
  end

  test "UpdateCategoryUsecase#call はカテゴリーを更新する" do
    params = { name: "Updated Name" }
    updated_category = @update_usecase.call(@category.id, params)

    assert_equal "Updated Name", updated_category.name
    assert_equal "Updated Name", @category.reload.name
  end

  test "DeleteCategoryUsecase#call はカテゴリーを削除する" do
    assert_difference("Category.count", -1) do
      @delete_usecase.call(@category.id)
    end
    assert_not Category.exists?(@category.id)
  end
end
