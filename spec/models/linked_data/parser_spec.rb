require 'spec_helper'

describe LinkedData::Parser do

  before(:each) do
    @parser = LinkedData::Parser.new
  end
  
  describe "class methods" do
    describe ".batch_serial_number" do
      it "should generate a unique serial number using MD5 hash seeded by current time and random number" do
        @sn1 = @parser.batch_serial_number
        @sn2 = @parser.batch_serial_number
        @sn1.should_not == @sn2
      end
    end

  end
  
  describe "basics" do
  end
  
end