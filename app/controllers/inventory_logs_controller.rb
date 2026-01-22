class InventoryLogsController < ApplicationController
  def index
    @item = Item.find(params[:item_id])
    @inventory_logs = @item.inventory_logs.order(created_at: :desc)
  end
end
