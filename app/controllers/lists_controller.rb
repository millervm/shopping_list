class ListsController < ApplicationController
    before_action :set_list, except: [:new, :create, :index]
    
    def new
        @list = List.new
        if params[:user_id]
            user = User.find_by(id: params[:user_id])
            if user
                verify_user(user)
            else
                flash[:notice] = "That is not a valid page."
                redirect_to user_lists_path(current_user)
            end
        end
    end
    
    def create
        @list = List.new(list_params)
        if @list
            if @list.user
                verify_user(@list.user) and return
            end
            if @list.save
                redirect_to list_path(@list)
            else
                flash[:notice] = @list.errors.messages.values.flatten.join("\n")
                render :new
            end
        else
            flash[:notice] = "Those are not valid list details. Please try again."
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
            @user = User.find_by(id: params[:user_id])
            if @user
                verify_user(@user)
                @lists = @user.lists
            else
                flash[:notice] = "That is not a valid page."
                redirect_to user_lists_path(current_user)
            end
        else
            flash[:notice] = "That is not a valid page."
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
            if User.find_by(id: params[:list][:user_id].to_i)
                verify_user(User.find_by(id: params[:list][:user_id].to_i)) and return
            end
            if @list.update(list_params)
                redirect_to list_path(@list)
            else
                flash[:notice] = @list.errors.messages.values.flatten.join("\n")
                render :edit
            end
        else
            flash[:notice] = "Those are not valid list details."
            if @list
                render :edit
            else
                redirect_to user_lists_path(current_user)
            end
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

    private
    
        def list_params
            params.require(:list).permit(:name, :user_id, :active)
        end
        
        def set_list
            @list = List.find_by(id: params[:id])
        end
        
end