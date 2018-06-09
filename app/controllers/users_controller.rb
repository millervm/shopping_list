class UsersController < ApplicationController
    
    def new
        @user = User.new
    end
    
    def create
        if params[:user].values.include?("")
            flash[:notice] =  "All fields are required."
            redirect_to new_user_path
        else
            @user = User.new(user_params)
            if @user.save
                session[:user_id] = @user.id
                redirect_to user_path(@user)
            else
                flash[:notice] = "Could not create account. Please try again."
                redirect_to new_user_path
            end
        end
    end
    
    def show
        @user = User.find_by(params[:id])
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