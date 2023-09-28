class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private
    def sign_up_params
      params.require(:registration).permit(:name, :email, :password, :password_confirmation)
    end

    def account_update_params
      params.require(:user).permit(:name, :email)
    end
end
