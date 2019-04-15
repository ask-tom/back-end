require 'jwt'

class Api::V1::AuthController < ApplicationController
	skip_before_action :authorized, only: [:create]

	def create
	  @user = User.find_by(username: user_login_params[:username])

	  if @user && @user.authenticate(user_login_params[:username])
	  	token = encode_token({ user_id: @user.id })
	  	render json: { user: UserSerializer.new(@user), jwt: token }, status: :accepted
	  else
	  	render json: { message: 'Invalid username or password' }, status: :anauthorized
	  end
	end

	private

	def user_login_params
		params.require(:user).permit(:name, :password)
	end

end
