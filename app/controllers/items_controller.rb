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

end
