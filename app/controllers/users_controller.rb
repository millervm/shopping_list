class UsersController < ApplicationController
    skip_before_action :require_login, only: [:new, :create]
    
    def new
        if logged_in?
            flash[:notice] = "You're already logged in!"
            redirect_to user_path(current_user)
        else
            @user = User.new
        end
    end
    
    def create
        @user = User.new(user_params)
            if @user.save
                session[:user_id] = @user.id
                redirect_to user_path(@user)
            else
                flash[:notice] = @user.errors.messages.values.flatten.join("\n")
                redirect_to new_user_path
            end
        # else
        #     redirect_to user_path(current_user)
        # end
    end
    
    def show
        @user = User.find_by(id: params[:id])
        if @user
            if @user != current_user
                flash[:notice] = "You do not have access to that page."
                redirect_to user_path(current_user)
            end
        else
            flash[:notice] = "That is not a valid page."
            redirect_to user_path(current_user)
        end
    end
    
    def edit
    end
    
    def update
    end
    
    private
    
    def user_params
        params.require(:user).permit(:name, :password)
    end
    
end