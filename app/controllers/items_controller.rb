class ItemsController < ApplicationController
    before_action :set_item, except: [:new, :create]

    def new
        @item = Item.new
        if params[:list_id]
            list = List.find_by(id: params[:list_id])
            if list 
                verify_user(list.user)
                @item.list = list
            else
                flash[:notice] = "That is not a valid page."
                redirect_to user_lists_path(current_user)
            end
        end
    end
    
    def create
        @item = Item.new(item_params)
        if @item 
            if @item.user
                verify_user(@item.user) and return
            end
            if @item.list.user
                verify_user(@item.list.user) and return
            end
            if @item.save
                redirect_to item_path(@item)
            else
                flash[:notice] = @item.errors.messages.values.flatten.join("\n")
                render :new
            end
        else
            flash[:notice] = "Those are not valid item details. Please try again."
            redirect_to new_item_path
        end
    end
    
    def show
        if @item 
            verify_user(@item.user)
        else
            flash[:notice] = "That is not a valid page."
            redirect_to user_lists_path(current_user)
        end
    end
    
    def edit
        if @item 
            verify_user(@item.user)
        else
            flash[:notice] = "That is not a valid item."
            redirect_to user_lists_path(current_user)
        end
    end
    
    def update
        if @item
            if User.find_by(id: params[:item][:user_id])
                verify_user(User.find_by(id: params[:item][:user_id])) and return
            end
            if List.find_by(id: params[:item][:list_id])
                verify_user(List.find_by(id: params[:item][:list_id])) and return
            end
            if @item.update(item_params)
                redirect_to item_path(@item)
            else
                flash[:notice] = @item.errors.messages.values.flatten.join("\n")
                render :edit
            end
        else
            flash[:notice] = "Those are not valid item details."
            redirect_to user_lists_path(current_user)
        end
    end
    
    def destroy
        if @item
            list = @item.list
            verify_user(@item.user)
            @item.destroy
            redirect_to list_path(list)
        else
            flash[:notice] = "That is not a valid page."
        end
    end
    
    private
    
        def item_params
            params.require(:item).permit(:name, :description, :urgent, :complete, :list_id, :user_id)
        end
        
        def set_item
            @item = Item.find_by(id: params[:id])
        end
    
end