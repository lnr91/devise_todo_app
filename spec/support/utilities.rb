def log_in user
  visit new_user_session_path         # can also write visit signin_path...since i added alias in routes.rb
  find("input[placeholder='email']").set(user.email)
  find("input[placeholder='password']").set(user.password)
  click_button 'Sign in'

end
