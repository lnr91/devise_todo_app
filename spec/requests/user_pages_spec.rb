require 'spec_helper'
describe 'UserPages' do
subject {page}
  describe 'Registration Page' do
    before { visit new_user_registration_path }
    it { should have_selector('title', text: 'Todoodle - Sign up') }
    it { should have_selector('form#new_user') }

  end
end