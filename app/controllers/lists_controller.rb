class ListsController < ApplicationController
    #add before_action verify_user
    #before_action set_list
    
    def new
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
    end
    
    def create
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
    end
    
    def show
        @list = List.find_by(id: params[:id])
        if @list
            if @list.user != current_user
                flash[:notice] = "You do not have access to that page."
                redirect_to user_lists_path(current_user)                end
            else
            flash[:notice] = "That is not a valid page."
            redirect_to user_lists_path(current_user)
        end
    end
    
    def index
        if params[:user_id]
            user = User.find_by(id: params[:user_id])
            if user && user == current_user
                @lists = user.lists
            else
                flash[:notice] = "You cannot access that page."
                redirect_to user_lists_path(current_user)
            end
        else
            @lists = current_user.lists
        end
    end
    
    def edit
        @list = List.find_by(id: params[:id])
        if @list
            if @list.user != current_user
                flash[:notice] = "You can only edit your own lists."
                redirect_to user_lists_path(current_user)
            end
        else
            flash[:notice] = "That is not a valid list."
            redirect_to user_lists_path(current_user)
        end
    end
    
    def update
        @list = List.find_by(id: params[:id])
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
    end
    
    def destroy
    end
    
    def show_complete
        @list = List.find_by(id: params[:id])
        if @list
            if @list.user != current_user
                flash[:notice] = "You do not have access to that page."
                redirect_to user_lists_path(current_user)
            else
                render :show
            end
        else
            flash[:notice] = "That is not a valid page."
            redirect_to user_lists_path(current_user)
        end
    end
        
    def show_urgent
        if params[:user_id]
            user = User.find_by(id: params[:user_id])
            if user && user == current_user
                @lists = user.lists
                render :index
            else
                flash[:notice] = "You cannot access that page."
                redirect_to user_lists_path(current_user)
            end
        else
            @lists = current_user.lists
        end
    end

    private
    
        def list_params
            params.require(:list).permit(:name, :user_id)
        end
        
end