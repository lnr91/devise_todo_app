require 'spec_helper'

describe User do

  before do
    @user = User.new(email: 'example@gmail.com', password: 'password', password_confirmation: 'password', nick_name: 'exmpl')
  end

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:nick_name) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:lists) }
  it { should respond_to(:encrypted_password) } #taken care of bydevise
  it { should respond_to(:reset_password_token) } #taken care of bydevise
  it { should be_valid }

  describe 'when email is not present' do
    before { @user.email='' }
    it { should_not be_valid }
  end
  describe 'when email format is invalid' do
    pending 'check for invalid email addresses'
  end
  describe 'when email id is already taken' do
    before do
      duplicate_user = @user.dup
      duplicate_user.save
    end
    it { should_not be_valid } #devise takes care of this for us...just to be sure , u can add a validates :email,unique:true to ur user model....notr ncessary
  end
  describe 'password too short' do
    before do
      @user.password = 'pas'
      @user.password_confirmation = 'pas'
    end
    it { should_not be_valid } #devise takes care of this
  end
  describe 'password and confirmation dont match' do
    before { @user.password_confirmation='notpassword' }
    it { should_not be_valid }
  end
  describe 'when nick name is not present' do
    before { @user.nick_name='' }
    it { should_not be_valid }
  end
  describe 'List associations' do
    before { @user.save }
    let!(:older_list) { Factory(:list, user: @user, created_at: 1.day.ago) }
    let!(:newer_list) { Factory(:list, user: @user, created_at: 1.hour.ago) }
    it 'should have lists in right order' do
      @user.lists.should eq [newer_list, older_list]
    end
    it 'should destroy associated lists' do
      lists = @user.lists
      @user.destroy
      lists.each do |list|
        expect do
          List.find(list.id)
        end.to raise_error ActiveRecord::RecordNotFound # can also write  end.should raise_error ....    both should and to are same
      end
    end

  end

end
