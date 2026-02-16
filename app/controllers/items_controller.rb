class ItemsController < ApplicationController
  def index
    @items = InventoryUsecases::ListItemsUsecase.new.call(category_id: params[:category_id], user: current_user)
    @categories = CategoryUsecases::ListCategoryUsecase.new.call(user: current_user)
  end

  def show
    @item, @inventory_logs = InventoryUsecases::ShowInventoryLogUsecase.new(user: current_user).call(params[:id])
  end

  def edit
    @item = current_user.items.find(params[:id])
    @categories = CategoryUsecases::ListCategoryUsecase.new.call(user: current_user)
  end

  def new
    @item = current_user.items.new
    @categories = CategoryUsecases::ListCategoryUsecase.new.call(user: current_user)
  end

  def create
    @item = InventoryUsecases::CreateItemUsecase.new(user: current_user).call(item_params)
    redirect_to items_path, notice: t("controllers.items.created", name: @item.name)
  rescue ActiveRecord::RecordInvalid => e
    @item = e.record
    @categories = CategoryUsecases::ListCategoryUsecase.new.call(user: current_user)
    flash.now[:alert] = t("controllers.items.failed_create", errors: @item.errors.full_messages.join('、'))
    render :new, status: :unprocessable_entity
  end

  def update
    @item = InventoryUsecases::UpdateItemUsecase.new(user: current_user).call(params[:id], item_update_params)
    flash.now[:notice] = t("controllers.items.updated", name: @item.name)
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(helpers.dom_id(@item, :info), partial: "items/details", locals: { item: @item }),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      end
      format.html { redirect_to item_path(@item), notice: t("controllers.items.updated", name: @item.name) }
    end
  rescue ActiveRecord::RecordInvalid => e
    @item = e.record
    @categories = CategoryUsecases::ListCategoryUsecase.new.call(user: current_user)
    flash.now[:alert] = t("controllers.items.failed_update")
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            helpers.dom_id(@item, :info),
            partial: "items/form",
            locals: { 
              item: @item, 
              categories: @categories, 
              title: t('views.items.form.edit_title'), 
              submit_label: t('views.items.form.update'), 
              cancel_path: item_path(@item), 
              cancel_data: { turbo_frame: helpers.dom_id(@item, :info) } 
            }
          ),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      end
      format.html { render :edit, status: :unprocessable_entity }
    end
  end

  def destroy
    InventoryUsecases::DeleteItemUsecase.new(user: current_user).call(params[:id])
    redirect_to items_path, notice: t("controllers.items.deleted")
  end

  def stock
    @item = current_user.items.find(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :quantity, :expiration_date, :category_id)
  end

  def item_update_params
    params.require(:item).permit(:name, :expiration_date, :category_id)
  end
end
