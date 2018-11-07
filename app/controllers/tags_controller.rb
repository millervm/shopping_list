class TagsController < ApplicationController
  
  def index
    @tags = Tag.all
  end
  
  def show
    @tag = Tag.find_by(id: params[:id])
    if !@tag
        flash[:notice] = "That is not a valid page."
        redirect_to user_path(current_user) 
    end
  end
    
end