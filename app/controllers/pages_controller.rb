class PagesController < ApplicationController

  def home
    if user_signed_in?
      @lists = current_user.lists.all    # Don't do current_user.lists
      @new_list = current_user.lists.build
    end
  end


end
