class ListsController < ApplicationController
  before_filter :authenticate_user!
  before_filter  {|c| c.correct_user params[:user_id] }   # Use block form ....This is the way to send parameters to method used in
  def create
    @list = current_user.lists.build(params[:list])
    respond_to do |format|
      format.js
    end
  end

  def show
    @list = List.find_by_id(params[:id])
    @task =@list.tasks.build
  end

  def destroy
    @list = List.find_by_id(params[:id])
    @destroyed_list = @list.destroy
    respond_to do |format|
      format.js
    end
  end

  def update
  end


end
