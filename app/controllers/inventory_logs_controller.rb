class InventoryLogsController < ApplicationController
  def index
    usecase = ShowInventoryLogUsecase.new
    @item, @inventory_logs = usecase.call(params[:item_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to items_path, alert: "アイテムが見つかりません"
  end
end
