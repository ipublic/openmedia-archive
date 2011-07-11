require 'spec_helper'

describe VCard::VCard do
  
  before(:each) do
    @last_name = "Mudd"
    @org_name = "Future Enterprises"
    @name = VCard::Name.new(:first_name => "Harcourt",
                                      :middle_name => "Fenton",
                                      :last_name => @last_name)
    
    @addr = VCard::Address.new(:type => "Home",
                                    :address_1 => "12 Rigel St",
                                    :address_2 => "Suite 101",
                                    :city => "Antares",
                                    :state => "AK",
                                    :zipcode => "99502",
                                    :country => "USA")
                                        
    @org = VCard::Organization.new(:name => @org_name, :department => "Sales")
    @email = VCard::Email.new(:type => "Work", :value => "my_name@example.com")
    @phone1 = VCard::Telephone.new(:type => "Work", :value => "202-555-1212")
    @phone2 = VCard::Telephone.new(:type => "Home", :value => "202-555-3434")
  end
  

  # it 'should require some portion of the name' do
  #   @vc = VCard::VCard.new
  #   @vc.should_not be_valid
  #   @vc.errors[:full_name].should_not be_nil
  # end
  
  it 'should save and generate an identifier correctly' do
    @vc = VCard::VCard.new(:name => @name, :organization => @org, :job_title => "Smuggler", :nickname => "Harry")
    @vc.addresses << @addr
    @vc.emails << @email
    @vc.telephones << @phone1 << @phone2

    lambda { @vc.save! }.should change(VCard::VCard, :count).by(1)
    @res = VCard::VCard.find_by_last_name(:key => @last_name)
    @res.organization.name.should == @org_name
  end

end