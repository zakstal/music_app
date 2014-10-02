class UsersController < ApplicationController

	before_action :require_sign_in!, only: [:show]
	before_action :require_sign_out!, only: [:new, :create]

	def new
		@user = User.new		
	end

	def create
		@user = User.find_by_credentails(
			user_params[:username],
			user_params[:password]
		)

		if @user.save
			sign_in(@user)
			user_url(@user)
		else
			flas[:errors] = @user.errors.full_message
			render :new
		end
					
	end

	def user_params
		params.require(:user).permit(:username, :password)
	end
end
