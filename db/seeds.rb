# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

dan = OpenMedia::Contact.create!(:first_name => 'Dan',
                            :last_name => 'Thomas',
                            :job_title => 'Chief Technology Officer',
                            :email => 'dan.thomas@ipublic.org')

dans_address = OpenMedia::Address.new(:city => 'Ellicott City',
                             :state_abbreviation => 'MD',
                             :zipcode => '21043',
                             :address_type => 'Business')
OpenMedia::Organization.create!({
  :name => 'iPublic, LLC', 
  :abbreviation => 'ipublic',
  :contacts => [dan],
  :addresses => [dans_address],
  :website_url => 'http://www.ipublic.org',
  :note => 'iPublic is creator and maintainer of Civic OpenMedia system'
  }
)

# create built-in schema domains/types
types_domain = OpenMedia::Schema::Domain.create!(:namespace=>'', :name=>'Types')

OpenMedia::Schema::Type.create!(:domain=>types_domain, :name=>'String')
OpenMedia::Schema::Type.create!(:domain=>types_domain, :name=>'Integer')
OpenMedia::Schema::Type.create!(:domain=>types_domain, :name=>'Date')
OpenMedia::Schema::Type.create!(:domain=>types_domain, :name=>'DateTime')

