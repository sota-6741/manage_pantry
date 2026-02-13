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
        render turbo_stream: turbo_stream.update(
          "adjustment_item_#{@item.id}",
          render_to_string(partial: "stock_adjustments/stock", locals: { item: @item })
        )
      end
    end
  rescue StandardError => e
    @item = Item.find(params[:item_id]) # エラー時にも@itemが必要
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "adjustment_item_#{@item.id}",
          render_to_string(partial: "stock_adjustments/form", locals: { item: @item, error_message: e.message })
        )
      end
      format.html { redirect_to items_path, alert: e.message }
    end
  end

  private

  def stock_adjustment_params
    params.require(:stock_adjustment).permit(:amount, :reason)
  end
end
