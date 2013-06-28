module CustomDeviseHelper1
  def devise_sessions_controller?
    is_a?(Devise::SessionsController)
  end

  def devise_registrations_controller?
    is_a?(Devise::RegistrationsController)
  end

  #For changing layout for specfic controller actions of devise
  def layout_by_resource
    if (devise_sessions_controller? || devise_registrations_controller?) && resource_name == :user
      "sessions"
    else
      "application"
    end
  end
end
