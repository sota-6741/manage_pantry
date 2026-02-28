class CategoriesController < ApplicationController
  def new
    @category = current_user.categories.new
  end

  def create
    @category = CategoryUsecases::CreateCategoryUsecase.new(user: current_user).call(category_params)
    @categories = CategoryUsecases::ListCategoryUsecase.new.call(user: current_user)
    notice_message = t("controllers.categories.created", name: @category.name)
    flash.now[:notice] = notice_message

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to items_path, notice: notice_message }
    end
  rescue ActiveRecord::RecordInvalid => e
    @category = e.record
    flash.now[:alert] = t("controllers.categories.failed", errors: @category.errors.full_messages.join("、"))

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("category_selector", partial: "categories/form", locals: { category: @category }),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      end
      format.html { render :new, status: :unprocessable_entity }
    end
  end

  def destroy
    CategoryUsecases::DeleteCategoryUsecase.new.call(params[:id])
    @categories = CategoryUsecases::ListCategoryUsecase.new.call(user: current_user)
    flash.now[:notice] = t("controllers.categories.deleted", default: "カテゴリーを削除しました")

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("category_selector", partial: "categories/selector", locals: { categories: @categories }),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      end
      format.html { redirect_to items_path(category_id: nil), notice: t("controllers.categories.deleted", default: "カテゴリーを削除しました") }
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
