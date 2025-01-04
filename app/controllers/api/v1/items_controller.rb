class Api::V1::ItemsController < ApplicationController
	before_action :authenticate_user!
  before_action :authorize_admin!, only: [:create, :update, :destroy]
  before_action :set_item, only: [:show, :update, :destroy]

  # GET /api/v1/items
  def index
    items = Item.where('name ILIKE ?', "%#{params[:query]}%").paginate(page: params[:page], per_page: params[:per_page])
    render json: items, status: :ok
  end

  # GET /api/v1/items/:id
  def show
    render json: @item, status: :ok
  end

  # POST /api/v1/items
  def create
    item = Item.new(item_params)
    if item.save
      render json: item, status: :created
    else
      render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/items/:id
  def update
    if @item.update(item_params)
      render json: @item, status: :ok
    else
      render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/items/:id
  def destroy
    @item.destroy
    render json: { message: 'Item deleted successfully' }, status: :ok
  end

  private

  def set_item
    @item = Item.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Item not found' }, status: :not_found
  end

  def item_params
    params.require(:item).permit(:name, :description, :price)
  end

  def authorize_admin!
    render json: { error: 'Access denied' }, status: :forbidden unless current_user&.admin?
  end
end
