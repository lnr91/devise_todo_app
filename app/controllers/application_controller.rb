class ApplicationController < ActionController::Base
  protect_from_forgery
  include CustomDeviseHelper1 #I named it with a 1 , because it doesn't seem to save if I save as custom_devise_helper.rb ....faced similar problem in another project....have to find out the problem

  layout :layout_by_resource #For changing layout for specfic controller actions of devise

end
