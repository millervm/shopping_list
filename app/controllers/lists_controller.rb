class ListsController < ApplicationController
    before_action :set_list, except: [:new, :create, :index, :show_urgent]
    
    def new
        if params[:user_id]
            user = User.find_by(id: params[:user_id])
            if user 
                verify_user(user)
                @list = List.new(user_id: user.id)
            end
        else
            @list = List.new(user_id: current_user.id)
        end
    end
    
    def create
        @list = List.new(list_params)
        verify_user(@list.user)
        if @list.save
            redirect_to list_path(@list)
        else
            flash[:notice] = @list.errors.messages.values.flatten.join("\n")
            redirect_to new_user_list_path(current_user)
        end
    end
    
    def show
        if @list
            verify_user(@list.user)
        else
            flash[:notice] = "That is not a valid page."
            redirect_to user_lists_path(current_user)
        end
    end
    
    def index
        if params[:user_id]
            user = User.find_by(id: params[:user_id])
            if user
                verify_user(user)
                @lists = user.lists
            else
                flash[:notice] = "That is not a valid page."
                redirect_to user_lists_path(current_user)
            end
        else
            @lists = current_user.lists
        end
    end
    
    def edit
        if @list
            verify_user(@list.user)
        else
            flash[:notice] = "That is not a valid list."
            redirect_to user_lists_path(current_user)
        end
    end
    
    def update
        if @list
            verify_user(@list.user)
            @list.update(list_params)
            if @list.save
                redirect_to list_path(@list)
            else
                flash[:notice] = @list.errors.messages.values.flatten.join("\n")
                redirect_to edit_list_path(@list)
            end
        else
            redirect_to user_lists_path(current_user)
        end
    end
    
    def destroy
        if @list
            verify_user(@list.user)
            @list.items.each {|item| item.destroy}
            @list.destroy
            redirect_to user_lists_path(current_user)
        else
            flash[:notice] = "That is not a valid page."
        end
    end
    
    def show_complete
        if @list
            verify_user(@list.user)
            render :show
        else
            flash[:notice] = "That is not a valid page."
            redirect_to user_lists_path(current_user)
        end
    end
        
    def show_urgent
        if params[:user_id]
            user = User.find_by(id: params[:user_id])
            if user 
                verify_user(user)
                @lists = user.lists
                render :index
            else
                flash[:notice] = "That is not a valid page."
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
        
        def set_list
            @list = List.find_by(id: params[:id])
        end
        
end