module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!
			before_action :authorize_admin!

      def index			
				users = User.all

				if params[:query].present?
					query = params[:query]
			
					if query.to_i.to_s == query
						id_users = users.where(id: query.to_i)
					else
						id_users = []
					end

					name_users = users.where('name ILIKE ?', "%#{query}%")
					users = id_users + name_users
				end

				limit = params[:limit].presence&.to_i || 10
				page = params[:page].presence&.to_i || 1
				offset = (page - 1) * limit
				paginated_users = users[offset, limit]

				render json: {
					status: { code: 200, message: 'Users fetched successfully' },
					data: paginated_users.map { |user| UserSerializer.new(user).serializable_hash[:data][:attributes] }
				}, status: :ok
      end
    end
  end
end
