require 'spec_helper'

shared_examples_for OpenMedia::Schema::Base do
  
  it 'should set created and modified on initial save' do
    base.should exist
    base.reload
    base.created.should be_instance_of(DateTime)
    base.modified.should be_instance_of(DateTime)
    base.created.should == base.modified
  end

  it 'should update modified on subsequent saves' do
    old_modified = base.modified
    base.save!
    base.modified.should_not == old_modified
    base.modified.should be > base.created
  end
end
