require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @category = categories(:one)
  end

  test "新規作成ページにアクセスできる" do
    get new_category_url
    assert_response :success
  end

  test "カテゴリーを作成できる" do
    assert_difference("Category.count", 1) do
      post categories_url, params: { category: { name: "New Category" } }
    end
    assert_redirected_to items_path
    assert_equal "カテゴリー「New Category」を追加しました", flash[:notice]
  end

  test "不正なパラメータではカテゴリーを作成できない" do
    assert_no_difference("Category.count") do
      post categories_url, params: { category: { name: "" } }
    end
    assert_response :unprocessable_entity
    assert_match "カテゴリー名を入力してください", flash[:alert]
  end

  test "カテゴリーを削除できる" do
    assert_difference("Category.count", -1) do
      delete category_url(@category)
    end
    assert_redirected_to items_path(category_id: nil)
  end
end
