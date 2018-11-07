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
            if @item.list && @item.list.user
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
            if User.find_by(id: params[:item][:user_id].to_i)
                verify_user(User.find_by(id: params[:item][:user_id].to_i)) and return
            end
            if List.find_by(id: params[:item][:list_id].to_i)
                verify_user(List.find_by(id: params[:item][:list_id].to_i).user) and return
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
    
    def add_tag
        tag = Tag.case_insensitive_find_or_create_by_name(params[:tag][:name])
        if @item
            verify_user(@item.user)
            if !tag.save
                flash[:notice] = tag.errors.messages.values.flatten.join("\n")
            elsif @item.tags.include?(tag)
                flash[:notice] = "Item already has that tag."
            else
                @item.tags << tag
            end
            redirect_to item_path(@item)
        else
            flash[:notice] = "That is not a valid page."
            redirect_to user_lists_path(current_user)
        end
    end
    
    def remove_tags
        if @item
            @item.tag_ids = params[:item][:tag_ids].collect {|id| id.to_i}.select {|tag| Tag.find_by(id: tag) && @item.tag_ids.include?(tag)}.uniq
            if !@item.save
                flash[:notice] = "Those are not valid item details."
            end
            redirect_to item_path(@item)
        else
            flash[:notice] = "That is not a valid page."
            redirect_to user_lists_path(current_user)
        end
    end
    
    private
    
        def item_params
            params.require(:item).permit(:name, :description, :urgent, :complete, :list_id, :user_id, tag_ids: [])
        end
        
        def set_item
            @item = Item.find_by(id: params[:id])
        end
    
end