class ItemsController < ApplicationController

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
      render json: items, include: :user, status: :ok
    else
      items = Item.all
      render json: items, include: :user, status: :ok
    end
  rescue ActiveRecord::RecordNotFound
    render json: {error: "User not found"}, status: :not_found
  end

  def show
    user = User.find(params[:user_id])
    item = user.items.find(params[:id])
    render json: item, include: :user, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Item not found"}, status: :not_found
  end

  def create
    user = User.find(params[:user_id])
    item = Item.create(item_params)
    user.items << item
    render json: item, status: :created
  rescue ActiveRecord::RecordNotFound
    render json: {error: "User not found"}, status: :not_found
  end

  private

  def item_params
    params.permit(:name, :description, :price)
  end


end
