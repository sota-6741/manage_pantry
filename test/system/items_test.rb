require "application_system_test_case"

class ItemsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    login_as @user
  end

  test "visiting the index" do
    visit items_url
    assert_selector "h1", text: "Manage Pantory"
  end
end
