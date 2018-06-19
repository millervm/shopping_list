class UsersController < ApplicationController
    
    def new
        if logged_in?
            flash[:notice] = "You're already logged in!"
            redirect_to user_path(current_user)
        else
            @user = User.new
        end
    end
    
    def create
        if !logged_in?
            @user = User.new(user_params)
            if @user.save
                session[:user_id] = @user.id
                redirect_to user_path(@user)
            else
                flash[:notice] = @user.errors.messages.values.flatten.join("\n")
                redirect_to new_user_path
            end
        else
            redirect_to user_path(current_user)
        end
    end
    
    def show
        @user = User.find_by(id: params[:id])
        if @user && logged_in?
            if @user == current_user
                render :show
            else
                flash[:notice] = "You cannot access that page."
                redirect_to user_path(current_user)
            end
        elsif !@user && logged_in?
            flash[:notice] = "That's not a valid page."
            redirect_to user_path(current_user)
        else
            flash[:notice] = "You must be logged in to access user details."
            redirect_to root_path
            #redirect_to '/login'
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