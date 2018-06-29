class ListsController < ApplicationController
    #before_action set_list
    
    def new
        if params[:user_id]
            user = User.find_by(id: params[:user_id])
            if user 
                verify_user(user)
                @list = List.new(user_id: user.id)
            end
        else
            #add flash notice? (not valid page)?
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
        @list = List.find_by(id: params[:id])
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
            #add flash notice?
            @lists = current_user.lists
        end
    end
    
    def edit
        @list = List.find_by(id: params[:id])
        if @list
            verify_user(@list.user)
        else
            flash[:notice] = "That is not a valid list."
            redirect_to user_lists_path(current_user)
        end
    end
    
    def update
        @list = List.find_by(id: params[:id])
        verify_user(@list.user)
        @list.update(list_params)
        if @list.save
            redirect_to list_path(@list)
        else
            flash[:notice] = @list.errors.messages.values.flatten.join("\n")
            redirect_to edit_list_path(@list)
        end
    end
    
    def destroy
    end
    
    def show_complete
        @list = List.find_by(id: params[:id])
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
            #add flash notice?
            @lists = current_user.lists
        end
    end

    private
    
        def list_params
            params.require(:list).permit(:name, :user_id)
        end
        
end