class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  respond_to :json

  def update_profile
    unless current_user.role == 'admin'
      return render json: {
        status: { code: 403, message: "You are not authorized to perform this action." }
      }, status: :forbidden
    end

    user = User.find_by(id: params[:id])
    unless user
      return render json: {
        status: { code: 404, message: "User not found." }
      }, status: :not_found
    end

    permitted_params = params.require(:user).permit(:first_name, :last_name, :email, :role)

    if user.update(permitted_params)
      render json: {
        status: { code: 200, message: "User profile updated successfully." },
        data: UserSerializer.new(user).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: "Failed to update user profile. #{user.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end

  def update
    if current_user
      permitted_params = params.require(:user).permit(:first_name, :last_name)
    else
      render json: {
        status: { code: 403, message: "You are not authorized to perform this action." }
      }, status: :forbidden and return
    end

    if current_user.update(permitted_params)
      render json: {
        status: { code: 200, message: "Account updated successfully." },
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: "Failed to update account. #{current_user.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end

  private

  def respond_with(resource, _opts = {})
    if request.method == "POST" && resource.persisted?
      render json: {
        status: { code: 200, message: "Signed up successfully." },
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }, status: :ok
    elsif request.method == "DELETE"
      render json: {
        status: { code: 200, message: "Account deleted successfully." }
      }, status: :ok
    elsif request.method.in?(%w[PATCH PUT]) && resource.errors.empty?
      render json: {
        status: { code: 200, message: "Account updated successfully." },
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: "Request couldn't be processed successfully. #{resource.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :role)
  end
end
