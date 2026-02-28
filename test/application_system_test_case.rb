require "test_helper"

class ApplicationSystemTestCase < ActionController::SystemTestCase
  # GitHub Actions などの CI 環境ではヘッドレスモードで実行します
  driven_by :selenium, using: :chrome, screen_size: [1440, 900] do |options|
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-gpu')
    options.add_argument('--disable-dev-shm-usage')
  end
end
