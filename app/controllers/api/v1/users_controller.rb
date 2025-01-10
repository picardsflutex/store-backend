module Api
  module V1
    class UsersController < ApplicationController

      def index			
				users = User.all

				if params[:query].present?
					query = params[:query]
			
					if query.to_i.to_s == query
						id_users = users.where(id: query.to_i)
					else
						id_users = []
					end

					firstname_users = users.where('first_name ILIKE ?', "%#{query}%")
					lastname_users = users.where('last_name ILIKE ?', "%#{query}%")

					firstname_users = firstname_users.reject { |user| id_users.include?(user) }
					lastname_users = lastname_users.reject { |user| id_users.include?(user) || firstname_users.include?(user) }

					users = id_users + firstname_users + lastname_users
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

			def authorize_admin!
				render json: { error: 'Access denied' }, status: :forbidden unless current_user&.admin?
			end
    end
  end
end
