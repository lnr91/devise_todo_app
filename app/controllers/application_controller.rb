class ApplicationController < ActionController::Base
  protect_from_forgery
  include CustomDeviseHelper1 #I named it with a 1 , because it doesn't seem to save if I save as custom_devise_helper.rb ....faced similar problem in another project....have to find out the problem
  include SessionsHelper1   #This only includes the helpers in the controller
  helper SessionsHelper1 #  To access these helpers in the views , you must use it....this is a rspec-rails 2.10.1 issue
  layout :layout_by_resource #For changing layout for specfic controller actions of devise
  before_filter :set_no_cache
  private
  def set_no_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

end
