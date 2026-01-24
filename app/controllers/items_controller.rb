class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def create
    usecase = Inventory::CreateItemUsecase.new
    @item = usecase.call(item_params)
    redirect_to new_item_path, notice: "アイテムを追加しました"
  rescue ActiveRecord::RecordInvalid => e
    # 保存失敗時は例外から item を取り出してフォームに渡す
    @item = e.record
    render :new, status: :unprocessable_entity
  end

  def update
    usecase = UpdateItemUsecase.new
    @item = usecase.call(params[:id], item_update_params)
    redirect_to items_path, notice: "アイテムを更新しました"
  rescue ActiveRecord::RecordInvalid => e
    @item = e.record
    render :edit, status: :unprocessable_entity
  end

  def destroy
    usecase = DeleteItemUsecase.new
    @item = usecase.call(params[:id])
    redirect_to items_path, notice: "アイテムを削除しました"
  end


  def change_stock
    usecase = Inventory::ChangeStockUsecase.new
    @item = usecase.call(
      item_id: params[:id],
      amount: change_stock_params[:amount].to_i,
      reason_key: change_stock_params[:reason]
    )
    redirect_to items_path, notice: "アイテムの在庫数を変更しました"
  rescue StandardError => e
    @item = Item.find(params[:id])
    flash.now[:alert] = e.message
    render :change_stock, status: :unprocessable_entity
  end

  private

  def item_params
    params.require(:item).permit(:name, :quantity, :expiration_date, :category_id)
  end

  def item_update_params
    params.require(:item).permit(:name, :expiration_date)
  end

  def change_stock_params
    params.require(:item).permit(:amount, :reason)
  end
end
