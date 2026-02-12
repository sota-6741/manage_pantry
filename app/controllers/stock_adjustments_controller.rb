class StockAdjustmentsController < ApplicationController
  helper ItemsHelper

  def new
    @item = Item.find(params[:item_id])
  end

  def create
    usecase = InventoryUsecases::ChangeStockUsecase.new
    @item = usecase.call(
      item_id: params[:item_id],
      amount: stock_adjustment_params[:amount].to_i,
      reason_key: stock_adjustment_params[:reason]
    )

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          dom_id(@item),
          partial: "items/item_card",
          locals: { item: @item }
        )
      end
      format.html { redirect_to items_path, notice: "アイテムの在庫数を変更しました" }
    end
  rescue StandardError => e
    redirect_to items_path, alert: e.message
  end

  private

  def stock_adjustment_params
    params.require(:stock_adjustment).permit(:amount, :reason)
  end
end
