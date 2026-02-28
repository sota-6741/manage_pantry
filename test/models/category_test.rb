require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @category = categories(:one)
  end

  test "バリデーション: 名前がない場合は無効" do
    category = Category.new(user: @user)
    assert_not category.valid?
    assert_includes category.errors[:name], "を入力してください"
  end

  test "バリデーション: 同じユーザー内で名前が重複している場合は無効" do
    duplicate_category = Category.new(name: @category.name, user: @user)
    assert_not duplicate_category.valid?
    assert_includes duplicate_category.errors[:name], "はすでに登録されています"
  end

  test "バリデーション: 異なるユーザーであれば同じ名前でも有効" do
    other_user = users(:two)
    other_category = Category.new(name: @category.name, user: other_user)
    assert other_category.valid?
  end

  test "アソシエーション: 複数のアイテムを持つことができる" do
    assert_respond_to @category, :items
  end

  test "削除時: カテゴリーを削除してもアイテムは削除されず、category_idがnullになる" do
    item = items(:one)
    item.update!(category: @category)
    
    @category.destroy
    assert_nil item.reload.category_id
  end
end
