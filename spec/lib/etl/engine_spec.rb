require 'spec_helper'

describe ETL::Engine do

  before :each do
    reset_test_db!
    @dataset = create_test_dataset(:title=>'Test')
    ETL::Engine.init
    ETL::Engine.realtime_activity=true
    
  end

  before :all do
    create_test_csv
    
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
    delete_test_csv
  end
  
  it 'initialize and store execution data in SITE_DATABASE' do
    OpenMedia::Import.count.should == 0
  end

  describe 'running etl from control string' do

    before :each do
      ETL::Engine.process_string(@dataset, @test_ctl)
    end
    
    it 'should create a Job in couchdb on each run' do
      OpenMedia::Import.count.should == 1
    end

    it 'should store ctl in job#control_file' do
      OpenMedia::Import.first.control_file.should == @test_ctl
    end

    it 'should store etl processing output in job#output' do
      OpenMedia::Import.first.output.should match(/Process/)
    end

    it 'should store errors in job#output or job#errors (not sure which yet)'

    it 'should store source csv data as attachment to Job' do
      OpenMedia::Import.first.attachments.size.should == 1
    end

    it 'should import data into Dataset destination' do
      @dataset.model.count.should == 2
    end
    
  end
  
end
