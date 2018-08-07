class ItemsController < ApplicationController
    before_action :set_item, except: [:new, :create]
    
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
        @item = Item.new(item_params)
        verify_user(@item.user)
        if @item.save
            redirect_to item_path(@item)
        else
            flash[:notice] = @item.errors.messages.values.flatten.join("\n")
            render :new
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
        if @item && List.find_by(id: params[:item][:list_id]) && User.find_by(id: params[:item][:user_id])
            verify_user(@item.user)
            @item.update(item_params)
            if @item.save
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