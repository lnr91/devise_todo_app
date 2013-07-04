require 'spec_helper'
describe 'StaticPages' do
  subject { page }
  describe 'Home page' do
    before { visit root_path }
    let(:user) { Factory(:user) }
    describe 'When not signed in' do
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
    describe 'On invalid sign in ' do
      before do
        find("input[placeholder='email']").set('bullshit')
        find("input[placeholder='password']").set('bullcraps')
        click_button 'Sign in'
      end
      it { should have_selector('div.alert.alert-error') }
    end
    describe 'When signed in' do
      before do
        visit root_path
        find("input[placeholder='email']").set(user.email)
        find("input[placeholder='password']").set(user.password)
        click_button 'Sign in'
      end
      it { should have_selector('div#user_nick_name',text:'Hi '+user.nick_name+' !') }
      it { should have_selector('title',text:'Todoodle - Home') }
    end
  end

    describe 'signup page' do


    end

end