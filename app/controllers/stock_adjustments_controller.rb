class StockAdjustmentsController < ApplicationController
  def create
    usecase = InventoryUsecases::ChangeStockUsecase.new
    @item = usecase.call(
      item_id: params[:item_id],
      amount: stock_adjustment_params[:amount].to_i,
      reason_key: stock_adjustment_params[:reason]
    )
    redirect_to items_path, notice: "アイテムの在庫数を変更しました"
  rescue StandardError => e
    redirect_to items_path, alert: e.message
  end

  private

  def stock_adjustment_params
    params.require(:stock_adjustment).permit(:amount, :reason)
  end
end
