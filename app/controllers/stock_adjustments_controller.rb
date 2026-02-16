class StockAdjustmentsController < ApplicationController
  helper ItemsHelper

  def new
    @item = current_user.items.find(params[:item_id])
  end

  def create
    usecase = InventoryUsecases::ChangeStockUsecase.new(user: current_user)
    @item = usecase.call(
      item_id: params[:item_id],
      amount: stock_adjustment_params[:amount].to_i,
      reason_key: stock_adjustment_params[:reason]
    )
    flash.now[:notice] = t("controllers.stock_adjustments.updated", name: @item.name)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            helpers.dom_id(@item, :adjustment),
            render_to_string(partial: "stock_adjustments/display", locals: { item: @item })
          ),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      end
    end
  rescue StandardError => e
    @item = current_user.items.find(params[:item_id]) # エラー時にも@itemが必要
    flash.now[:alert] = t("controllers.stock_adjustments.failed", errors: e.message)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            helpers.dom_id(@item, :adjustment),
            render_to_string(partial: "stock_adjustments/form", locals: { item: @item, error_message: e.message })
          ),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      end
      format.html { redirect_to items_path, alert: e.message }
    end
  end

  private

  def stock_adjustment_params
    params.require(:stock_adjustment).permit(:amount, :reason)
  end
end
