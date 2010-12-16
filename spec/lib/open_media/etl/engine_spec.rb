require 'spec_helper'

describe OpenMedia::ETL::Engine do

  before :each do
    reset_test_db!
    OpenMedia::ETL::Engine.init
    OpenMedia::ETL::Engine.realtime_activity=true
    @dataset = create_test_dataset(:title=>'Test')    
  end

  before :all do
    File.open('/tmp/test.csv', 'w') do |f|
      f.puts('A,B,C,D')
      f.puts('1,2,3,4')
      f.puts('5,6,7,8')            
    end

    @test_ctl = <<eos
source :in, {
  :file => "/tmp/test.csv",
  :parser => :delimited,
  :skip_lines => 1
}, 
[
  :A,
  :B,
  :C,
  :D
]

destination :out, {
  :dataset => 'Test'
}, {
  :order=>[:A, :B, :D]
}
eos
    # File.open('/tmp/test.ctl', 'w') {|f| f.write(@test_ctl)}
  end

  after :all do
    File.delete('/tmp/test.csv')    
  end
  
  it 'initialize and store execution data in SITE_DATABASE' do
    OpenMedia::ETL::Execution::Job.count.should == 0
  end

  describe 'running etl from control string' do

    before :each do
      OpenMedia::ETL::Engine.process_string(@test_ctl)
    end
    
    it 'should create a Job in couchdb on each run' do
      OpenMedia::ETL::Execution::Job.count.should == 1
    end

    it 'should store ctl in job#control_file' do
      OpenMedia::ETL::Execution::Job.first.control_file.should == @test_ctl
    end

    it 'should store etl processing output in job#output' do
      OpenMedia::ETL::Execution::Job.first.output.should match(/Process/)
    end

    it 'should store errors in job#output or job#errors (not sure which yet)'

    it 'should store source csv data as attachment to Job' do
      OpenMedia::ETL::Execution::Job.first.attachments.size.should == 1
    end

    it 'should import data into Dataset destination' do
      @dataset.model.count.should == 2
    end    
    
  end
  
end
