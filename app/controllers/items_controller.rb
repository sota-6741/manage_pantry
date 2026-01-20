class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      # 成功した場合はUX的に新規作成画面にリダイレクトした方が使いやすいかも
      redirect_to new_item_path, notice: "アイテムを追加しました"
    else
      # 失敗したらパラメータを残して新規作成画面に戻す
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

    if @item.consume(amount)
      redirect_to items_path, notice: "在庫を消費しました"
    else
      redirect_to items_path, alert: @item.errors.full_messages.to_sentence
    end
  end

  def dispose
    @item = Item.find(params[:id])

    amount = params[:amount].to_i

    if @item.dispose(amount)
      redirect_to items_path, notice: "在庫を破棄しました"
    else
      redirect_to items_path, alert: @item.errors.full_messages.to_sentence
    end
  end

  def purchase
    @item = Item.find(params[:id])

    amount = params[:amount].to_i

    if @item.purchase(amount)
      redirect_to items_path, notice: "在庫を追加しました"
    else
      redirect_to items_path, alert: @item.errors.full_messages.to_sentence
    end
  end

end
