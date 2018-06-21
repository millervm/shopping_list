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
    end
    
    def show
        @list = List.find_by(id: params[:id])
        if @list
          if @list.user != current_user
            flash[:notice] = "You do not have access to that page."
            redirect_to user_lists_path(current_user)
          end
        else
            flash[:notice] = "That is not a valid page."
            redirect_to user_lists_path(current_user)
        end
    end
    
    def index
        if logged_in?
            if params[:user_id]
                user = User.find_by(id: params[:user_id])
                if !user.nil? && user == current_user
                    @lists = user.lists
                else
                    flash[:notice] = "You cannot access that page."
                    redirect_to user_lists_path(current_user)
                end
            else
                @lists = current_user.lists
            end
        else
            flash[:notice] = "You must be logged in to view lists."
            redirect_to root_path
        end
    end
    
    def edit
        @list = List.find_by(id: params[:id])
        if logged_in?
            if @list.user != current_user
                flash[:notice] = "You can only edit your own lists."
                redirect_to user_lists_path(current_user)
            end
        else
            flash[:notice] = "You must be logged in to edit your lists."
            redirect_to root_path
        end
    end
    
    def update
        @list = List.find_by(id: params[:id])
        if logged_in?
            if @list.user == current_user
                @list.update(list_params)
                if @list.save
                    redirect_to list_path(@list)
                else
                    flash[:notice] = @list.errors.messages.values.flatten.join("\n")
                    redirect_to edit_list_path(@list)
                end
            else
                flash[:notice] = "You do not have access to that page."
                redirect_to user_lists_path(current_user)
            end
        else
            flash[:notice] = "You must be logged in to edit your lists."
            redirect_to root_path
        end
    end
    
    def destroy
    end
    
    private
    
    def list_params
        params.require(:list).permit(:name, :user_id)
    end

end