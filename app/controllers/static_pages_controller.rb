class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:privacy, :terms], raise: false

  def privacy
  end

  def terms
  end
end
