class SessionsController < ApplicationController
    
    def new
        if logged_in?
            flash[:notice] = "You're already logged in."
            redirect_to user_path(current_user)
        else
            render :new
        end
    end

    def create
        if params.values.include?("")
            flash[:notice] = "Please enter both fields."
            redirect_to '/login'
        else
            @user = User.find_by(name: params[:username])
            if @user && @user.authenticate(params[:password])
                session[:user_id] = @user.id
                redirect_to user_path(@user)
            else
                flash[:notice] = "Incorrect login details. Please try again or sign up for an account."
                redirect_to '/login'
            end
        end
    end
    
    def destroy
        session.delete :user_id
        redirect_to root_path
    end
    
end