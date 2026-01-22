class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def create
    @item = InventoryService.create_item(item_params)

    # サービスが返したオブジェクトがDBに保存済み（＝成功）かチェック
    if @item.persisted?
      redirect_to new_item_path, notice: "アイテムを追加しました"
    else
      # 失敗時はエラーの入った@itemを使い、新規作成画面を再描画
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @item = Item.find(params[:id])

    @item.destroy
    redirect_to items_path, notice: "アイテムを削除しました"
  end

  def update
    @item = Item.find(params[:id])

    if @item.update(item_params)
      redirect_to items_path, notice: "アイテムを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def consume
    @item = Item.find(params[:id])
    amount = params[:amount].to_i

    if InventoryService.change_quantity(item: @item, amount: amount, reason: :consume)
      redirect_to items_path, notice: "在庫を消費しました"
    else
      redirect_to items_path, alert: @item.errors.full_messages.to_sentence
    end
  end

  def dispose
    @item = Item.find(params[:id])
    amount = params[:amount].to_i

    if InventoryService.change_quantity(item: @item, amount: amount, reason: :dispose)
      redirect_to items_path, notice: "在庫を破棄しました"
    else
      redirect_to items_path, alert: @item.errors.full_messages.to_sentence
    end
  end

  def purchase
    @item = Item.find(params[:id])
    amount = params[:amount].to_i

    if InventoryService.change_quantity(item: @item, amount: amount, reason: :purchase)
      redirect_to items_path, notice: "在庫を追加しました"
    else
      redirect_to items_path, alert: @item.errors.full_messages.to_sentence
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :quantity, :expiration_date)
  end
end
