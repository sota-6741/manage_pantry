class InventoryLogsController < ApplicationController
  def index
    @item, @inventory_logs = InventoryUsecases::ShowInventoryLogUsecase.new(user: current_user).call(params[:item_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to items_path, alert: "アイテムが見つかりません"
  end
end
