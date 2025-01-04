module Api
  module V1
    class OrdersController < ApplicationController
      before_action :authenticate_user!

      # /api/v1/orders
      def create
        ActiveRecord::Base.transaction do
          user = current_user

          order = Order.create!(user_id: user.id, amount: 0)

          order_descriptions = params[:items].map do |item|
            item_id = item[:item_id]
            quantity = item[:quantity]

            item_record = Item.find(item_id)
            price_at_purchase = item_record.price
            order.amount += price_at_purchase * quantity

            {
              order_id: order.id,
              item_id: item_id,
              quantity: quantity,
              price: price_at_purchase
            }
          end

          order_descriptions.each do |order_description|
						OrderDescription.create!(order_description)
					end
					
          order.save!

          render json: { message: 'Order created successfully', order_id: order.id }, status: :created
        end
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      # /api/v1/orders
      def index
        user = current_user
        orders = user.orders.includes(:order_descriptions).map do |order|
          {
            id: order.id,
            amount: order.amount,
            items: order.order_descriptions.map do |desc|
              {
                item_id: desc.item_id,
                quantity: desc.quantity,
                price: desc.price
              }
            end
          }
        end

        render json: orders, status: :ok
      end

      private

      def current_user
				payload = jwt_payload
				if payload.blank?
					return nil
				end			
				user = User.find_by(id: payload['sub'])			
				user
			end			

      def jwt_payload
				auth_header = request.headers['Authorization']
				if auth_header.blank?
					render json: { error: 'Authorization header is missing' }, status: :unauthorized
					return
				end
			
				token = auth_header.split(' ').last
			
				secret_key = ENV.fetch('JWT_SECRET') { Rails.application.credentials.fetch(:secret_key_base) }
				decoded_token = JWT.decode(token, secret_key, true, { algorithm: 'HS256' }).first
			
				decoded_token
			rescue JWT::DecodeError => e
				render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized
				nil
			end
			
    end
  end
end
