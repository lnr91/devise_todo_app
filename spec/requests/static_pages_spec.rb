require 'spec_helper'
describe 'StaticPages' do
  subject { page }
  describe 'Home page' do

    describe 'When not signed in' do
      before { visit root_path }
      it { should have_selector('title', text: 'Todoodle - Welcome') }
      it { should have_selector('a', text: 'Sign up now !') } # same as below
      it { should have_link('Sign up now !') }
      it { should have_selector('form#signin_form_header') }
      it { should have_selector("input[placeholder='email']") }
      it { should have_selector("input[placeholder='password']") }
      it 'should have right links to other pages on layout' do
        click_link 'Sign up now !'
        page.should have_selector('title', text: 'Todoodle - Sign up')
        visit root_path
        click_link 'Todoodle'
        page.should have_selector('title', text: 'Todoodle - Welcome')
      end
    end

  end

end