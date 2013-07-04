require 'spec_helper'
describe 'UserPages' do
  Capybara.default_wait_time = 5
  WAIT_FOR_HIDING = 0.00001 #This is the time interval I give befor checking whether the element go thidden or not
  WAIT_FOR_MODEL = 0.6 #Time required to wait bfore active record model count gets increased
  subject { page }
  describe 'Signup Page' do
    before { visit new_user_registration_path }
    it { should have_selector('title', text: 'Todoodle - Sign up') }
    it { should have_selector('h2', text: 'Sign up') }
  end
  describe 'Signup' do
    before { visit new_user_registration_path }
    let(:submit) { "Sign up" }
    describe 'with invalid information' do
      it 'should not create a new user' do
        expect do
          click_button :submit
        end.not_to change(User, :count)
      end
      describe 'after submission' do
        pending 'check for javascript validations of devise'
      end
    end

    describe 'with valid information' do
      before do
        fill_in 'Email', with: 'example@gmail.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        fill_in 'Nick name', with: 'exmpl'
      end
      it 'should increase user count by 1' do
        expect do
          click_button :submit
        end.to change(User, :count).by(1)
      end
      describe 'after saving the user' do
        before { click_button :submit }
        let(:user) { User.find_by_email('example@gmail.com') }
        it { should have_selector('div#user_nick_name', text: 'Hi '+user.nick_name+' !') }
        it { should have_link('Logout') }
        it { should have_selector('div.alert.alert-success') }
      end
    end
  end
  describe 'editing user profile' do
    let(:user) { Factory(:user) }
    before do
      log_in user
      visit edit_user_path(user)
    end
    it { should have_selector('h2', text: 'Edit profile') }
    describe 'putting empty nick name' do
      before do
        fill_in 'Nick name', with: ''
        click_button 'Update profile'
      end
      it 'should not submit form' do
        page.should have_selector('div.user_nick_name')
      end
    end
    describe 'putting valid nick name' do
      before do
        fill_in 'Nick name', with: 'simha'
        click_button 'Update profile'
      end
      it { should have_selector('div#user_nick_name', text: 'Hi '+user.reload.nick_name+' !') }
      specify { user.reload.nick_name.should eq 'simha' }
    end
  end
  describe 'home/lists page ' do
    let(:user) { Factory(:user) }
    before do
      log_in user
      visit root_path
    end
    describe ' on page' do

      describe 'when no lists are present' do
        it { should have_selector('div#lists_empty', text: 'You have no lists ! Create a list now !') }
      end
      describe 'when many lists are present' do
        before(:all) { 5.times { Factory(:list, user: user) } }
        it 'should show all lists and their delete links' do
          user.lists.each do |list|
            page.should have_selector('li a', text: list.name)
            page.should have_link('(remove)', href: user_list_path(user, list))
          end
        end
        pending 'no empty message', js: true do
          page.should have_selector('div#lists_empty')
        end
        pending 'test links to lists' do
          it 'should have links to all lists' do
            user.lists.each do |list|
              click_link list.name
              page.should have_selector('title', text: 'Todoodle - '+list.name)
            end
          end
        end
      end
    end
    describe 'adding a list' do
      before do
        fill_in 'Name', with: 'myList'
        fill_in 'Description', with: 'myDescription'
      end
      it 'increase List count', js: true do
        expect do
          click_button 'Create List'
          sleep(WAIT_FOR_MODEL)
        end.should change(List, :count).by(1)
      end

      describe 'showing the added list' do
        before { click_button 'Create List' }
        it 'show newly added list', js: true do
          page.should have_selector('li a', text: 'myList')
        end
        it 'should remove the empty message when list is added', js: true do
          sleep(WAIT_FOR_HIDING)
          page.should have_selector('div#lists_empty', visible: false)
          #find('div#lists_empty').should_not be_visible    #can write this also
        end

        describe 'and then removing the list', js: true do
          before do
            sleep(WAIT_FOR_MODEL) #Put some delay here,bcos when u create a new list it takes time for model count to be updated...thats why
          end
          it 'should remove list element from page', js: true do
            click_link '(remove)'
            page.should have_no_selector('li a', text: 'myList')
            page.should have_selector('h3', text: 'My TODO Lists')
          end

          it 'should change lists count by -1' do
            expect do
              click_link '(remove)'
              sleep(WAIT_FOR_MODEL)
            end.to change(List, :count).by(-1)
          end
        end
      end
    end
  end
  describe 'List page..tasks' do
    let(:user) { Factory(:user) }
    let(:list) { Factory(:list, user: user) }
    before do
      log_in user
      visit user_list_path(user, list)
    end
    it { should have_selector('title', text: 'Todoodle - '+list.name) }
    it { should have_selector('form#new_task') }
    it { should have_selector('h2', text: list.name) }
    describe 'adding a task' do
      before do
        fill_in 'Description', with: "mytask"
      end
      it 'should increase task count', js: true do
        expect do
          click_button 'Create Task'
          sleep(WAIT_FOR_MODEL)
        end.should change(Task, :count).by(1)
      end

      describe 'on the page', js: true do
        before { click_button 'Create Task' }
        it { should have_selector('label', text: 'mytask') }

        it 'should decrease count and remove task on clicking remove' do
          sleep(WAIT_FOR_MODEL)
          expect do
            click_link 'remove'
            sleep(WAIT_FOR_MODEL)
          end.should change(Task, :count).by(-1)
          page.should_not have_selector('label', text: 'mytask')
          page.should have_selector('h2', text: list.name)
        end
      end


    end

    describe 'User interaction with tasks', js: true do

      before do
        fill_in 'Description', with: 'Task 1'
        click_button 'Create Task'
      end
      it 'should add and show task if u fill in form and add', js: true do
        page.should have_selector('label', text: 'Task 1')
      end
      it 'should remove incomplete task on clicking remove button', js: true do
        page.find('div#incomplete_tasks > form').click_link('remove')
        page.should_not have_selector('label', text: 'Task 1')
      end
      it 'should mark tasks  as complete', js: true do
        page.find('div#incomplete_tasks > form > label').click #The child combinator (E > F) can be thought of as a more specific form of the descendant combinator (E F) in that it selects only first-level descendants.
        page.should have_selector('div#completed_tasks > form > label', text: 'Task 1')
        page.should_not have_selector('div#incomplete_tasks > form > label', text: 'Task 1')
      end
      describe 'completed tasks' do
        before do
          page.find('div#incomplete_tasks > form > label').click
        end
        it 'should remove completed task on clicking remove button', js: true do
          page.find('div#completed_tasks > form').click_link('remove')
          page.should_not have_selector('div#completed_tasks > form > label', text: 'Task 1')
        end
        it 'should re-mark tasks  as incomplete when complete task is clicked', js: true do
          page.find('div#completed_tasks > form > label').click
          page.should have_selector('div#incomplete_tasks > form > label', text: 'Task 1')
          page.should_not have_selector('div#completed_tasks > form > label', text: 'Task 1')
        end
      end
    end
  end

  describe 'index page' do
    let(:user) { Factory(:user) }
    before(:all) do
      40.times { Factory(:user) }
    end
    before(:each) do
      log_in user
      visit users_path
    end
    after(:all) { User.delete_all }
    it { should have_selector('title',text: 'All users')}
    it { should have_selector('h2', text: 'All users') }
    it 'should show names of all users' do
      User.all.each do |user|
        page.should have_selector('li', text: user.nick_name)
      end
    end


  end

end