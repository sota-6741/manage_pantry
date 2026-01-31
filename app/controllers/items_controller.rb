class ItemsController < ApplicationController
  def index
    items_usecase = InventoryUsecases::ListItemsUsecase.new
    @items = items_usecase.call(category_id: params[:category_id])

    categories_usecase = CategoryUsecases::ListCategoryUsecase.new
    @categories = categories_usecase.call
  end

  def new
    @item = Item.new
    categories_usecase = CategoryUsecases::ListCategoryUsecase.new
    @categories = categories_usecase.call
  end

  def create
    usecase = InventoryUsecases::CreateItemUsecase.new
    @item = usecase.call(item_params)
    redirect_to new_item_path, notice: "アイテムを追加しました"
  rescue ActiveRecord::RecordInvalid => e
    # 保存失敗時は例外から item を取り出してフォームに渡す
    @item = e.record
    render :new, status: :unprocessable_entity
  end

  def update
    usecase = InventoryUsecases::UpdateItemUsecase.new
    @item = usecase.call(params[:id], item_update_params)
    redirect_to items_path, notice: "アイテムを更新しました"
  rescue ActiveRecord::RecordInvalid => e
    @item = e.record
    render :edit, status: :unprocessable_entity
  end

  def destroy
    usecase = InventoryUsecases::DeleteItemUsecase.new
    @item = usecase.call(params[:id])
    redirect_to items_path, notice: "アイテムを削除しました"
  end

  private

  def item_params
    params.require(:item).permit(:name, :quantity, :expiration_date, :category_id)
  end

  def item_update_params
    params.require(:item).permit(:name, :expiration_date)
  end
end
