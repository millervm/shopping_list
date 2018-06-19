class ListsController < ApplicationController
    
    def new
        if logged_in?
            if params[:user_id]
                user = User.find_by(id: params[:user_id])
                if !user.nil? && user == current_user
                    @list = List.new(user_id: user.id)
                else
                    flash[:notice] = "You can only create a list for your own account."
                    redirect_to new_list_path
                end
            else
                @list = List.new(user_id: current_user.id)
            end
        else
            flash[:notice] = "You must be logged in to create lists."
            redirect_to root_path
        end
    end
    
    def create
        if logged_in?
            @list = List.new(list_params)
            if @list.user == current_user
                if @list.save
                    redirect_to list_path(@list)
                else
                    flash[:notice] = @list.errors.messages.values.flatten.join("\n")
                    redirect_to new_user_list_path(current_user)
                end
            else
                flash[:notice] = "You can only create a list for your own account."
                redirect_to new_user_list_path(current_user)
            end
        else
            redirect_to root_path
        end
        #if params[:list][:user_id].to_i == current_user.id
            #@list = List.new(list_params)
            #if @list.user == current_user
            #    if @list.save
            #        redirect_to list_path(@list)
             #   else
              #      flash[:notice] = @list.errors.messages.values
               #     redirect_to new_user_list_path(current_user)
            #    end
            #else
            #    flash[:notice] = "You can only create a list for your own account."
            #    redirect_to new_user_list_path(current_user)
            #end
    end
    
    def show
    end
    
    def index
    end
    
    def edit
    end
    
    def update
    end
    
    def destroy
    end
    
    private
    
    def list_params
        params.require(:list).permit(:name, :user_id)
    end

end