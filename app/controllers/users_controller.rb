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
            render :new
        end
    end
    
    def show
        @user = User.find_by(id: params[:id])
        if @user
            verify_user(@user)
        else
            flash[:notice] = "That is not a valid page."
            redirect_to user_path(current_user)
        end
    end
    
    def edit
        @user = User.find_by(id: params[:id])
        if @user
            verify_user(@user)
        else
            flash[:notice] = "That is not a valid page."
            redirect_to user_path(current_user)
        end
    end
    
    def update
        @user = User.find_by(id: params[:id])
        if @user 
            verify_user(@user)
            @user.update(user_params)
            if @user.authenticate(params[:user][:current_password])
                if @user.save
                    redirect_to user_path(@user)
                else
                    flash[:notice] = @user.errors.messages.values.flatten.join("\n")
                    render :edit
                end
            else
                flash[:notice] = "Incorrect password. Please try again."
                render :edit
            end
        else
            flash[:notice] = "That is not a valid page."
            redirect_to user_path(current_user)
        end
    end
    
    def show_urgent
        @user = User.find_by(id: params[:id])
        if @user
            verify_user(@user)
            render :show
        else
            flash[:notice] = "That is not a valid page."
            redirect_to user_path(current_user)
        end
    end
    
    private
    
    def user_params
        params.require(:user).permit(:name, :password)
    end
    
end