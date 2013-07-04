class TasksController < ApplicationController

  before_filter :authenticate_user!
  before_filter  {|c| c.correct_user params[:user_id] }   # Use block form ....This is the way to send parameters to method used in
  before_filter :find_list
  def create
    @task = @list.tasks.build(params[:task])
    respond_to do |format|
      format.js
    end
  end


  def update
    @task =@list.tasks.find(params[:id])
    @task.update_attributes(params[:task])
    respond_to do |format|
      format.js
    end
  end

  def destroy
   @destroyed_task = @list.tasks.destroy(params[:id])
   @destroyed_task = @destroyed_task.first    # we do this bcos , above command returns an rray of destroyed task objects
   respond_to do |format|
     format.js
   end
  end

  private

  def find_list
    redirect_to root_path unless @list= current_user.lists.find_by_id(params[:list_id])
  end
end
