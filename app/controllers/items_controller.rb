class ItemsController < ApplicationController
    #before_action verify_login
    #before_action set_item
    #before_action verify_user
    
    def new
        if logged_in?
            if params[:list_id]
                list = List.find_by(id: params[:list_id])
                if !list.nil? && list.user == current_user
                    @item = Item.new(list_id: list.id)
                else
                    if list.user != current_user
                        flash[:notice] = "You can only add items to your own lists."
                    elsif list.nil?
                        flash[:notice] = "That is not a valid list."
                    end
                    redirect_to user_lists_path(current_user)
                end
            else
                flash[:notice] = "You must select a list to add an item."
                redirect_to user_lists_path(current_user)
            end
        else
            flash[:notice] = "You must be logged in to add items."
            redirect_to root_path
        end
    end
    
    def create
        if logged_in?
            @item = Item.new(item_params)
            if @item.user == current_user
                if @item.save
                    redirect_to item_path(@item)
                else
                    flash[:notice] = @item.errors.messages.values.flatten.join("\n")
                    redirect_to new_list_item_path(@item.list)
                end
            else
                flash[:notice] = "You can only add items to your own lists."
                redirect_to user_lists_path(current_user)
            end
        else
            redirect_to root_path
        end
    end
    
    def show
    end
    
    def edit
    end
    
    def update
    end
    
    def destroy
    end
    
    private
    
        def item_params
            params.require(:item).permit(:name, :description, :urgent, :complete, :list_id, :user_id)
        end
    
end