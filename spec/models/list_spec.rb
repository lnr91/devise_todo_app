require 'spec_helper'

describe List do

  let(:user) { Factory(:user) }
  before do
    @list = user.lists.build(name: 'My List', description: 'My List Description')
  end
  subject { @list }
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:user) }
  its(:user) {should eq user}        # can also write : should == user  .... or should eq(user) ...it tries like so ...user1 == user 2
  it { should be_valid }           # don't use should be user ....becos it tries like so :  user1.equal?(user2) ...even if it is same user record, object id differs so it fails test
  describe 'when name is not present' do
    before { @list.name = ''}
    it { should_not be_valid }
  end
  describe 'when user id is not present' do
    before { @list.user = nil }
    it { should_not be_valid }
  end
  describe 'accessible attributes' do
    it 'shouldnt allow access to user id' do
      expect do
        List.new(name: 'My List', description: 'My List Description',user: user)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

end
