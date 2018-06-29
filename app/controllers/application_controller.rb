class ApplicationController < ActionController::Base
    helper_method :current_user
    helper_method :logged_in?
    
    before_action :require_login, except: [:home]
    
    def home
    end
    
    private
    
        def current_user
            User.find_by(id: session[:user_id])    
        end
        
        def logged_in?
            session[:user_id]
        end
    
        def require_login
            unless logged_in?
                flash[:notice] = "You must be logged in to access that page."
                redirect_to root_path
            end
        end
        
        def verify_user(user)
            if user != current_user   
                flash[:notice] = "You do not have access to that page."
                redirect_to user_path(user)
            end
        end
        
end