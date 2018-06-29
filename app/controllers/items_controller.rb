class ItemsController < ApplicationController
    #before_action set_item
    
    def new
        if params[:list_id]
            list = List.find_by(id: params[:list_id])
            if list
                verify_user(list.user)
                @item = Item.new(list_id: list.id)
            else
                flash[:notice] = "That is not a valid list."
                redirect_to user_lists_path(current_user)
            end
        else
            flash[:notice] = "You must select a list to add an item."
            redirect_to user_lists_path(current_user)
        end
    end
    
    def create
        @item = Item.new(item_params
        verify_user(@item.user)
        if @item.save
            redirect_to item_path(@item)
        else
            flash[:notice] = @item.errors.messages.values.flatten.join("\n")
            redirect_to new_list_item_path(@item.list)
        end
    end
    
    def show
        @item = Item.find_by(id: params[:id])
        if @item
            verify_user(@item.user)
        else
            flash[:notice] = "That is not a valid page."
            redirect_to user_lists_path(current_user)
        end
    end
    
    def edit
        @item = Item.find_by(id: params[:id])
        if @item
            verify_user(@item.user)
        else
            flash[:notice] = "That is not a valid item."
            redirect_to user_lists_path(current_user)
        end
    end
    
    def update
        @item = Item.find_by(id: params[:id])
        if @item
            verify_user(@item.user)
            @item.update(item_params)
            if @item.save
                redirect_to item_path(@item)
            else
                flash[:notice] = @item.errors.messages.values.flatten.join("\n")
                redirect_to edit_item_path(@item)
            end
        else
            flash[:notice] = "That is not a valid item."
            redirect_to user_lists_path(current_user)
        end
    end
    
    def destroy
    end
    
    private
    
        def item_params
            params.require(:item).permit(:name, :description, :urgent, :complete, :list_id, :user_id)
        end
    
end