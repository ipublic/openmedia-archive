require 'spec_helper'

describe OpenMedia::VCard do

  it 'should require some portion of the name' do
    @vc = OpenMedia::VCard.new
    @vc.should_not be_valid
    @vc.errors[:full_name].should_not be_nil
  end
  
  it 'should save and generate an identifier correctly' do
    @last_name = "Mudd"
    @org_name = "Future Enterprises"
    @org = OpenMedia::Organization.new(:name => @org_name, :department => "Sales")
    @email = OpenMedia::Email.new(:type => "Work", :value => "my_name@example.com")
    @phone1 = OpenMedia::Telephone.new(:type => "Work", :value => "202-555-1212")
    @phone2 = OpenMedia::Telephone.new(:type => "Home", :value => "202-555-3434")
    @addr = OpenMedia::Address.new(:type => "Home",
                                    :address_1 => "12 Rigel St",
                                    :address_2 => "Suite 101",
                                    :city => "Antares",
                                    :state => "AK",
                                    :zipcode => "99502",
                                    :country => "USA")
    
    @vc = OpenMedia::VCard.new(:first_name => "Harcourt", 
                                :middle_name => "Fenton", 
                                :last_name => @last_name, 
                                :nickname => "Harry",
                                :job_title => "Smuggler",
                                :organization => @org)
    @vc.email << @email
    @vc.telephone << @phone1 << @phone2
    @vc.address << @addr

    lambda { @vc.save! }.should change(OpenMedia::VCard, :count).by(1)
    @res = OpenMedia::VCard.find_by_last_name(:key => @last_name)
    @res.organization.name.should == @org_name
  end

end