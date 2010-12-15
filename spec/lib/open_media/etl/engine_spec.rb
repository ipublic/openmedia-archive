require 'spec_helper'

describe OpenMedia::ETL::Engine do

  before :each do
    reset_test_db!
    OpenMedia::ETL::Engine.init
    OpenMedia::ETL::Engine.realtime_activity=true    
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
eos
    File.open('/tmp/test.ctl', 'w') {|f| f.write(@test_ctl)}
  end

  after :all do
    File.delete('/tmp/test.csv')    
  end
  
  it 'initialize and store execution data in SITE_DATABASE' do
    OpenMedia::ETL::Execution::Job.count.should == 0
  end

  it 'should be able to run ctl' do
    OpenMedia::ETL::Engine.process('/tmp/test.ctl')
    OpenMedia::ETL::Execution::Job.count.should == 1
  end

  it 'should store ctl in job#control_file' do
    OpenMedia::ETL::Engine.process('/tmp/test.ctl')
    OpenMedia::ETL::Execution::Job.first.control_file.should == @test_ctl
  end
  
end
