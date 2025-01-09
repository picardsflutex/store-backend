class Api::V1::ItemsController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_admin!, only: [:create, :update, :destroy]
  before_action :set_item, only: [:show, :update, :destroy]

  # GET /api/v1/items
  def index
    items = Item.all

    if params[:query].present?
      query = params[:query]
  
      if query.to_i.to_s == query
        id_items = items.where(id: query.to_i)
      else
        id_items = []
      end
  
      name_items = items.where('name ILIKE ?', "%#{query}%")

      items = id_items + name_items
    end

    limit = params[:limit].presence&.to_i || 10
    page = params[:page].presence&.to_i || 1
    offset = (page - 1) * limit
    paginated_items = items[offset, limit]

    render json: paginated_items, status: :ok
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
