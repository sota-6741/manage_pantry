class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_locale

  skip_before_action :authenticate_user!, only: [:render_404, :render_500]

  # 開発環境でもエラー画面を確認したい場合はコメントアウトを外す
  # unless Rails.env.development?
    rescue_from StandardError, with: :render_500
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  # end

  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e
    render template: 'errors/404', status: :not_found, layout: 'application'
  end

  def render_500(e = nil)
    logger.error "Rendering 500 with exception: #{e.message}" if e
    render template: 'errors/500', status: :internal_server_error, layout: 'application'
  end

  private

  def set_locale
    I18n.locale = :ja
  end
end
