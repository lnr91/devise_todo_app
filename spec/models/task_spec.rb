require 'spec_helper'

describe Task do
  let(:list) { Factory(:list) }
  before do
    @task = list.tasks.build(description:'My Task')
  end

  subject {@task}
  it {should respond_to(:description) }
  it {should respond_to(:list) }
  its(:list) {should eq list}

  describe 'when description not present' do
    before {@task.description = ' '}
    it {should_not be_valid}
  end

  describe 'when list id not present' do
    before {@task.list = nil}
    it {should_not be_valid}
  end

  describe 'accessible attributes' do

    it 'shouldnt allow access to list id' do
      expect do
        Task.new(description:'some task',list:list)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end



end
