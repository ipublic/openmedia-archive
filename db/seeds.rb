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

## Add Default Catalogs
date_stamp = Date.today.to_json

#OpenMedia::Catalog.create!({
#  :title => 'Staging', 
#  :database_store => 'staging', 
#  :metadata => {
#    :description => "A workspace for transforming, curating and preparing Datasets for publication.  Staging catalog contents are visible only to local site.",
#    :dcmi_type => 'Dataset',
#    :language => 'en-US',
#    :beginning_date => date_stamp,
#    :ending_date => date_stamp,
#    :created_date => date_stamp,
#    :last_updated => date_stamp,
#    :license => ''
#    # :uri
#    # :creator_organization_id
#    # :publisher_organization_id
#    # :maintainer_organization_id
#    # :conforms_to => 
#    # :geographic_coverage  => # Geographic bounds, jurisdiction name from controlled vocab, 
#    # :update_frequency, :alias => :accrual_periodity # , :alias => :update_interval_in_minutes
#    # :released, :type => Date  #, :alias => :date, :cast_as => 'Date', :init_method => 'parse'
#    # :license, :alias => :rights
#  }
#})
#
#
#OpenMedia::Catalog.create!({
#  :title => 'Commmunity', 
#  :database_store => 'community', 
#  :metadata => {
#    :description => 'A repository for data, templates and content shared among OpenMedia community members. Community catalog contents are shared with other OpenMedia sites.',
#    :type => 'Dataset',
#    :language => 'en-US',
#    :creator_organization_id => OpenMedia::Organization.by_name(:key => "iPublic, LLC").first.identifier.to_s,
#    :publisher_organization_id => OpenMedia::Organization.by_name(:key => "iPublic, LLC").first.identifier.to_s,
#    :maintainer_organization_id => OpenMedia::Organization.by_name(:key => "iPublic, LLC").first.identifier.to_s,
#    :created_date => date_stamp,
#    :last_updated => date_stamp,
#    :released => date_stamp,
#    :license => ''
#    # :conforms_to => 
#    # :uri =>
#    # :geographic_coverage  => # Geographic bounds, jurisdiction name from controlled vocab, 
#    # :update_frequency, :alias => :accrual_periodity # , :alias => :update_interval_in_minutes
#    # :beginning_date => date_stamp,
#    # # :ending_date => date_stamp
#  }
#})
#  
#OpenMedia::Catalog.create!({
#  :title => 'Public', 
#  :database_store => 'public', 
#  :metadata => {
#    :description => "Published Datasets. Public catalog contents are accessible to the public.",
#    :dcmi_type => 'Dataset',
#    :language => 'en-US',
#    :beginning_date => date_stamp,
#    :ending_date => date_stamp,
#    :created_date => date_stamp,
#    :last_updated => date_stamp,
#    :license => ''
#    # :uri
#    # :creator_organization_id
#    # :publisher_organization_id
#    # :maintainer_organization_id
#    # :conforms_to => 
#    # :geographic_coverage  => # Geographic bounds, jurisdiction name from controlled vocab, 
#    # :update_frequency, :alias => :accrual_periodity # , :alias => :update_interval_in_minutes
#  }
#})


### STATES
#puts "Loading US State documents..."
#State.new({:abbreviation => 'AL', :state_fips_code => '01', :name => 'ALABAMA'}).save
#State.new({:abbreviation => 'AK', :state_fips_code => '02', :name => 'ALASKA'}).save
#State.new({:abbreviation => 'AZ', :state_fips_code => '04', :name => 'ARIZONA'}).save
#State.new({:abbreviation => 'AR', :state_fips_code => '05', :name => 'ARKANSAS'}).save
#State.new({:abbreviation => 'CA', :state_fips_code => '06', :name => 'CALIFORNIA'}).save
#State.new({:abbreviation => 'CO', :state_fips_code => '08', :name => 'COLORADO'}).save
#State.new({:abbreviation => 'CT', :state_fips_code => '09', :name => 'CONNECTICUT'}).save
#State.new({:abbreviation => 'DE', :state_fips_code => '10', :name => 'DELAWARE'}).save
#State.new({:abbreviation => 'DC', :state_fips_code => '11', :name => 'DISTRICT OF COLUMBIA'}).save
#State.new({:abbreviation => 'FL', :state_fips_code => '12', :name => 'FLORIDA'}).save
#State.new({:abbreviation => 'GA', :state_fips_code => '13', :name => 'GEORGIA'}).save
#State.new({:abbreviation => 'HI', :state_fips_code => '15', :name => 'HAWAII'}).save
#State.new({:abbreviation => 'ID', :state_fips_code => '16', :name => 'IDAHO'}).save
#State.new({:abbreviation => 'IL', :state_fips_code => '17', :name => 'ILLINOIS'}).save
#State.new({:abbreviation => 'IN', :state_fips_code => '18', :name => 'INDIANA'}).save
#State.new({:abbreviation => 'IA', :state_fips_code => '19', :name => 'IOWA'}).save
#State.new({:abbreviation => 'KS', :state_fips_code => '20', :name => 'KANSAS'}).save
#State.new({:abbreviation => 'KY', :state_fips_code => '21', :name => 'KENTUCKY'}).save
#State.new({:abbreviation => 'LA', :state_fips_code => '22', :name => 'LOUISIANA'}).save
#State.new({:abbreviation => 'ME', :state_fips_code => '23', :name => 'MAINE'}).save
#State.new({:abbreviation => 'MD', :state_fips_code => '24', :name => 'MARYLAND'}).save
#State.new({:abbreviation => 'MA', :state_fips_code => '25', :name => 'MASSACHUSETTS'}).save
#State.new({:abbreviation => 'MI', :state_fips_code => '26', :name => 'MICHIGAN'}).save
#State.new({:abbreviation => 'MN', :state_fips_code => '27', :name => 'MINNESOTA'}).save
#State.new({:abbreviation => 'MS', :state_fips_code => '28', :name => 'MISSISSIPPI'}).save
#State.new({:abbreviation => 'MO', :state_fips_code => '29', :name => 'MISSOURI'}).save
#State.new({:abbreviation => 'MT', :state_fips_code => '30', :name => 'MONTANA'}).save
#State.new({:abbreviation => 'NE', :state_fips_code => '31', :name => 'NEBRASKA'}).save
#State.new({:abbreviation => 'NV', :state_fips_code => '32', :name => 'NEVADA'}).save
#State.new({:abbreviation => 'NH', :state_fips_code => '33', :name => 'NEW HAMPSHIRE'}).save
#State.new({:abbreviation => 'NJ', :state_fips_code => '34', :name => 'NEW JERSEY'}).save
#State.new({:abbreviation => 'NM', :state_fips_code => '35', :name => 'NEW MEXICO'}).save
#State.new({:abbreviation => 'NY', :state_fips_code => '36', :name => 'NEW YORK'}).save
#State.new({:abbreviation => 'NC', :state_fips_code => '37', :name => 'NORTH CAROLINA'}).save
#State.new({:abbreviation => 'ND', :state_fips_code => '38', :name => 'NORTH DAKOTA'}).save
#State.new({:abbreviation => 'OH', :state_fips_code => '39', :name => 'OHIO'}).save
#State.new({:abbreviation => 'OK', :state_fips_code => '40', :name => 'OKLAHOMA'}).save
#State.new({:abbreviation => 'OR', :state_fips_code => '41', :name => 'OREGON'}).save
#State.new({:abbreviation => 'PA', :state_fips_code => '42', :name => 'PENNSYLVANIA'}).save
#State.new({:abbreviation => 'RI', :state_fips_code => '44', :name => 'RHODE ISLAND'}).save
#State.new({:abbreviation => 'SC', :state_fips_code => '45', :name => 'SOUTH CAROLINA'}).save
#State.new({:abbreviation => 'SD', :state_fips_code => '46', :name => 'SOUTH DAKOTA'}).save
#State.new({:abbreviation => 'TN', :state_fips_code => '47', :name => 'TENNESSEE'}).save
#State.new({:abbreviation => 'TX', :state_fips_code => '48', :name => 'TEXAS'}).save
#State.new({:abbreviation => 'UT', :state_fips_code => '49', :name => 'UTAH'}).save
#State.new({:abbreviation => 'VT', :state_fips_code => '50', :name => 'VERMONT'}).save
#State.new({:abbreviation => 'VA', :state_fips_code => '51', :name => 'VIRGINIA'}).save
#State.new({:abbreviation => 'WA', :state_fips_code => '53', :name => 'WASHINGTON'}).save
#State.new({:abbreviation => 'WV', :state_fips_code => '54', :name => 'WEST VIRGINIA'}).save
#State.new({:abbreviation => 'WI', :state_fips_code => '55', :name => 'WISCONSIN'}).save
#State.new({:abbreviation => 'WY', :state_fips_code => '56', :name => 'WYOMING'}).save
#State.new({:abbreviation => 'AS', :state_fips_code => '60', :name => 'AMERICAN SAMOA'}).save
#State.new({:abbreviation => 'GU', :state_fips_code => '66', :name => 'GUAM'}).save
#State.new({:abbreviation => 'PR', :state_fips_code => '72', :name => 'PUERTO RICO'}).save
#State.new({:abbreviation => 'VI', :state_fips_code => '78', :name => 'VIRGIN ISLANDS'}).save
#
#### COUNTIES
#
## ContentDocument.new({
##   :title => 'US Counties',
## #  :uri => 'http://db.civicopenmedia.org/us_counties',
##   :metadata => {
##     :type => "Dataset",
##     :keywords => ["us", "counties", "fips code"],
##     :language => "en-US",
##     :conforms_to => "",
##     :geographic_coverage => "United States county and borough names",
##     :update_frequency => 0,
##     :creator_organization_id => Organization.get("organizations_ipublic").identifier,
##     :publisher_organization_id => Organization.get("organizations_ipublic").identifier,
##     :maintainer_organization_id => Organization.get("organizations_ipublic").identifier,
##     :license => "Public domain",
##     :description => "Names of United States incorporated counties and boroughs"
##     },
##   :properties => [
##     {:name => "name", :data_type => "String", :example_value => "Anchorage Borough", :definition => "Full county/borough name" },
##     {:name => "state_fips_code", :data_type => "String", :example_value => "02", :definition => "Two character Federal Information Processing Standards (FIPS) Code for state" },
##     {:name => "county_fips_code", :data_type => "String", :example_value => "020", :definition => "Three character Federal Information Processing Standards (FIPS) Code for county" }
##     ]
##   }
## ).save
#
#puts "Clearing existing US County documents..."
## Clear existing documents
#County.all.each do |doc|
#  doc.destroy
#end
#
## Load County values
#puts "Loading US County documents..."
#County.new({:state_fips_code => "02", :county_fips_code => "013", :name => "Aleutians East Borough"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "016", :name => "Aleutians West Census Area"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "020", :name => "Anchorage Borough"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "050", :name => "Bethel Census Area"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "060", :name => "Bristol Bay Borough"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "070", :name => "Dillingham Census Area"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "090", :name => "Fairbanks North Star Borough"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "100", :name => "Haines Borough"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "110", :name => "Juneau Borough"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "122", :name => "Kenai Peninsula Borough"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "130", :name => "Ketchikan Gateway Borough"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "150", :name => "Kodiak Island Borough"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "164", :name => "Lake and Peninsula Borough"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "170", :name => "Matanuska-Susitna Borough"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "180", :name => "Nome Census Area"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "185", :name => "North Slope Borough"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "188", :name => "Northwest Arctic Borough"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "201", :name => "Prince of Wales-Outer Ketchikan Census Area"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "220", :name => "Sitka Borough"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "231", :name => "Skagway-Yakutat-Angoon Census Area"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "240", :name => "Southeast Fairbanks Census Area"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "261", :name => "Valdez-Cordova Census Area"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "270", :name => "Wade Hampton Census Area"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "280", :name => "Wrangell-Petersburg Census Area"}).save
#County.new({:state_fips_code => "02", :county_fips_code => "290", :name => "Yukon-Koyukuk Census Area"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "001", :name => "Autauga County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "003", :name => "Baldwin County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "005", :name => "Barbour County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "007", :name => "Bibb County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "009", :name => "Blount County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "011", :name => "Bullock County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "013", :name => "Butler County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "015", :name => "Calhoun County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "017", :name => "Chambers County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "019", :name => "Cherokee County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "021", :name => "Chilton County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "023", :name => "Choctaw County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "025", :name => "Clarke County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "027", :name => "Clay County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "029", :name => "Cleburne County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "031", :name => "Coffee County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "033", :name => "Colbert County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "035", :name => "Conecuh County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "037", :name => "Coosa County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "039", :name => "Covington County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "041", :name => "Crenshaw County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "043", :name => "Cullman County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "045", :name => "Dale County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "047", :name => "Dallas County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "049", :name => "DeKalb County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "051", :name => "Elmore County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "053", :name => "Escambia County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "055", :name => "Etowah County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "057", :name => "Fayette County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "059", :name => "Franklin County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "061", :name => "Geneva County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "063", :name => "Greene County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "065", :name => "Hale County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "067", :name => "Henry County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "069", :name => "Houston County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "071", :name => "Jackson County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "073", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "075", :name => "Lamar County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "077", :name => "Lauderdale County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "079", :name => "Lawrence County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "081", :name => "Lee County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "083", :name => "Limestone County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "085", :name => "Lowndes County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "087", :name => "Macon County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "089", :name => "Madison County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "091", :name => "Marengo County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "093", :name => "Marion County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "095", :name => "Marshall County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "097", :name => "Mobile County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "099", :name => "Monroe County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "101", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "103", :name => "Morgan County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "105", :name => "Perry County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "107", :name => "Pickens County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "109", :name => "Pike County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "111", :name => "Randolph County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "113", :name => "Russell County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "115", :name => "St. Clair County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "117", :name => "Shelby County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "119", :name => "Sumter County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "121", :name => "Talladega County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "123", :name => "Tallapoosa County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "125", :name => "Tuscaloosa County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "127", :name => "Walker County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "129", :name => "Washington County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "131", :name => "Wilcox County"}).save
#County.new({:state_fips_code => "01", :county_fips_code => "133", :name => "Winston County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "001", :name => "Arkansas County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "003", :name => "Ashley County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "005", :name => "Baxter County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "007", :name => "Benton County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "009", :name => "Boone County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "011", :name => "Bradley County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "013", :name => "Calhoun County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "015", :name => "Carroll County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "017", :name => "Chicot County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "019", :name => "Clark County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "021", :name => "Clay County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "023", :name => "Cleburne County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "025", :name => "Cleveland County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "027", :name => "Columbia County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "029", :name => "Conway County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "031", :name => "Craighead County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "033", :name => "Crawford County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "035", :name => "Crittenden County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "037", :name => "Cross County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "039", :name => "Dallas County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "041", :name => "Desha County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "043", :name => "Drew County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "045", :name => "Faulkner County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "047", :name => "Franklin County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "049", :name => "Fulton County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "051", :name => "Garland County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "053", :name => "Grant County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "055", :name => "Greene County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "057", :name => "Hempstead County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "059", :name => "Hot Spring County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "061", :name => "Howard County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "063", :name => "Independence County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "065", :name => "Izard County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "067", :name => "Jackson County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "069", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "071", :name => "Johnson County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "073", :name => "Lafayette County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "075", :name => "Lawrence County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "077", :name => "Lee County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "079", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "081", :name => "Little River County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "083", :name => "Logan County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "085", :name => "Lonoke County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "087", :name => "Madison County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "089", :name => "Marion County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "091", :name => "Miller County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "093", :name => "Mississippi County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "095", :name => "Monroe County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "097", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "099", :name => "Nevada County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "101", :name => "Newton County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "103", :name => "Ouachita County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "105", :name => "Perry County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "107", :name => "Phillips County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "109", :name => "Pike County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "111", :name => "Poinsett County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "113", :name => "Polk County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "115", :name => "Pope County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "117", :name => "Prairie County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "119", :name => "Pulaski County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "121", :name => "Randolph County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "123", :name => "St. Francis County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "125", :name => "Saline County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "127", :name => "Scott County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "129", :name => "Searcy County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "131", :name => "Sebastian County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "133", :name => "Sevier County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "135", :name => "Sharp County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "137", :name => "Stone County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "139", :name => "Union County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "141", :name => "Van Buren County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "143", :name => "Washington County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "145", :name => "White County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "147", :name => "Woodruff County"}).save
#County.new({:state_fips_code => "05", :county_fips_code => "149", :name => "Yell County"}).save
#County.new({:state_fips_code => "04", :county_fips_code => "001", :name => "Apache County"}).save
#County.new({:state_fips_code => "04", :county_fips_code => "003", :name => "Cochise County"}).save
#County.new({:state_fips_code => "04", :county_fips_code => "005", :name => "Coconino County"}).save
#County.new({:state_fips_code => "04", :county_fips_code => "007", :name => "Gila County"}).save
#County.new({:state_fips_code => "04", :county_fips_code => "009", :name => "Graham County"}).save
#County.new({:state_fips_code => "04", :county_fips_code => "011", :name => "Greenlee County"}).save
#County.new({:state_fips_code => "04", :county_fips_code => "012", :name => "La Paz County"}).save
#County.new({:state_fips_code => "04", :county_fips_code => "013", :name => "Maricopa County"}).save
#County.new({:state_fips_code => "04", :county_fips_code => "015", :name => "Mohave County"}).save
#County.new({:state_fips_code => "04", :county_fips_code => "017", :name => "Navajo County"}).save
#County.new({:state_fips_code => "04", :county_fips_code => "019", :name => "Pima County"}).save
#County.new({:state_fips_code => "04", :county_fips_code => "021", :name => "Pinal County"}).save
#County.new({:state_fips_code => "04", :county_fips_code => "023", :name => "Santa Cruz County"}).save
#County.new({:state_fips_code => "04", :county_fips_code => "025", :name => "Yavapai County"}).save
#County.new({:state_fips_code => "04", :county_fips_code => "027", :name => "Yuma County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "001", :name => "Alameda County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "003", :name => "Alpine County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "005", :name => "Amador County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "007", :name => "Butte County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "009", :name => "Calaveras County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "011", :name => "Colusa County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "013", :name => "Contra Costa County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "015", :name => "Del Norte County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "017", :name => "El Dorado County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "019", :name => "Fresno County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "021", :name => "Glenn County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "023", :name => "Humboldt County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "025", :name => "Imperial County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "027", :name => "Inyo County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "029", :name => "Kern County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "031", :name => "Kings County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "033", :name => "Lake County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "035", :name => "Lassen County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "037", :name => "Los Angeles County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "039", :name => "Madera County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "041", :name => "Marin County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "043", :name => "Mariposa County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "045", :name => "Mendocino County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "047", :name => "Merced County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "049", :name => "Modoc County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "051", :name => "Mono County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "053", :name => "Monterey County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "055", :name => "Napa County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "057", :name => "Nevada County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "059", :name => "Orange County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "061", :name => "Placer County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "063", :name => "Plumas County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "065", :name => "Riverside County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "067", :name => "Sacramento County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "069", :name => "San Benito County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "071", :name => "San Bernardino County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "073", :name => "San Diego County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "075", :name => "San Francisco County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "077", :name => "San Joaquin County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "079", :name => "San Luis Obispo County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "081", :name => "San Mateo County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "083", :name => "Santa Barbara County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "085", :name => "Santa Clara County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "087", :name => "Santa Cruz County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "089", :name => "Shasta County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "091", :name => "Sierra County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "093", :name => "Siskiyou County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "095", :name => "Solano County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "097", :name => "Sonoma County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "099", :name => "Stanislaus County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "101", :name => "Sutter County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "103", :name => "Tehama County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "105", :name => "Trinity County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "107", :name => "Tulare County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "109", :name => "Tuolumne County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "111", :name => "Ventura County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "113", :name => "Yolo County"}).save
#County.new({:state_fips_code => "06", :county_fips_code => "115", :name => "Yuba County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "001", :name => "Adams County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "003", :name => "Alamosa County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "005", :name => "Arapahoe County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "007", :name => "Archuleta County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "009", :name => "Baca County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "011", :name => "Bent County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "013", :name => "Boulder County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "015", :name => "Chaffee County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "017", :name => "Cheyenne County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "019", :name => "Clear Creek County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "021", :name => "Conejos County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "023", :name => "Costilla County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "025", :name => "Crowley County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "027", :name => "Custer County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "029", :name => "Delta County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "031", :name => "Denver County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "033", :name => "Dolores County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "035", :name => "Douglas County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "037", :name => "Eagle County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "039", :name => "Elbert County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "041", :name => "El Paso County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "043", :name => "Fremont County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "045", :name => "Garfield County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "047", :name => "Gilpin County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "049", :name => "Grand County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "051", :name => "Gunnison County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "053", :name => "Hinsdale County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "055", :name => "Huerfano County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "057", :name => "Jackson County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "059", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "061", :name => "Kiowa County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "063", :name => "Kit Carson County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "065", :name => "Lake County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "067", :name => "La Plata County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "069", :name => "Larimer County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "071", :name => "Las Animas County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "073", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "075", :name => "Logan County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "077", :name => "Mesa County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "079", :name => "Mineral County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "081", :name => "Moffat County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "083", :name => "Montezuma County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "085", :name => "Montrose County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "087", :name => "Morgan County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "089", :name => "Otero County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "091", :name => "Ouray County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "093", :name => "Park County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "095", :name => "Phillips County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "097", :name => "Pitkin County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "099", :name => "Prowers County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "101", :name => "Pueblo County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "103", :name => "Rio Blanco County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "105", :name => "Rio Grande County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "107", :name => "Routt County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "109", :name => "Saguache County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "111", :name => "San Juan County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "113", :name => "San Miguel County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "115", :name => "Sedgwick County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "117", :name => "Summit County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "119", :name => "Teller County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "121", :name => "Washington County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "123", :name => "Weld County"}).save
#County.new({:state_fips_code => "08", :county_fips_code => "125", :name => "Yuma County"}).save
#County.new({:state_fips_code => "09", :county_fips_code => "001", :name => "Fairfield County"}).save
#County.new({:state_fips_code => "09", :county_fips_code => "003", :name => "Hartford County"}).save
#County.new({:state_fips_code => "09", :county_fips_code => "005", :name => "Litchfield County"}).save
#County.new({:state_fips_code => "09", :county_fips_code => "007", :name => "Middlesex County"}).save
#County.new({:state_fips_code => "09", :county_fips_code => "009", :name => "New Haven County"}).save
#County.new({:state_fips_code => "09", :county_fips_code => "011", :name => "New London County"}).save
#County.new({:state_fips_code => "09", :county_fips_code => "013", :name => "Tolland County"}).save
#County.new({:state_fips_code => "09", :county_fips_code => "015", :name => "Windham County"}).save
#County.new({:state_fips_code => "11", :county_fips_code => "001", :name => "District of Columbia"}).save
#County.new({:state_fips_code => "10", :county_fips_code => "001", :name => "Kent County"}).save
#County.new({:state_fips_code => "10", :county_fips_code => "003", :name => "New Castle County"}).save
#County.new({:state_fips_code => "10", :county_fips_code => "005", :name => "Sussex County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "001", :name => "Alachua County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "003", :name => "Baker County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "005", :name => "Bay County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "007", :name => "Bradford County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "009", :name => "Brevard County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "011", :name => "Broward County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "013", :name => "Calhoun County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "015", :name => "Charlotte County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "017", :name => "Citrus County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "019", :name => "Clay County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "021", :name => "Collier County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "023", :name => "Columbia County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "025", :name => "Dade County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "027", :name => "DeSoto County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "029", :name => "Dixie County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "031", :name => "Duval County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "033", :name => "Escambia County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "035", :name => "Flagler County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "037", :name => "Franklin County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "039", :name => "Gadsden County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "041", :name => "Gilchrist County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "043", :name => "Glades County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "045", :name => "Gulf County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "047", :name => "Hamilton County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "049", :name => "Hardee County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "051", :name => "Hendry County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "053", :name => "Hernando County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "055", :name => "Highlands County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "057", :name => "Hillsborough County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "059", :name => "Holmes County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "061", :name => "Indian River County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "063", :name => "Jackson County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "065", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "067", :name => "Lafayette County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "069", :name => "Lake County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "071", :name => "Lee County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "073", :name => "Leon County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "075", :name => "Levy County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "077", :name => "Liberty County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "079", :name => "Madison County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "081", :name => "Manatee County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "083", :name => "Marion County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "085", :name => "Martin County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "087", :name => "Monroe County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "089", :name => "Nassau County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "091", :name => "Okaloosa County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "093", :name => "Okeechobee County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "095", :name => "Orange County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "097", :name => "Osceola County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "099", :name => "Palm Beach County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "101", :name => "Pasco County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "103", :name => "Pinellas County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "105", :name => "Polk County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "107", :name => "Putnam County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "109", :name => "St. Johns County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "111", :name => "St. Lucie County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "113", :name => "Santa Rosa County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "115", :name => "Sarasota County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "117", :name => "Seminole County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "119", :name => "Sumter County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "121", :name => "Suwannee County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "123", :name => "Taylor County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "125", :name => "Union County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "127", :name => "Volusia County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "129", :name => "Wakulla County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "131", :name => "Walton County"}).save
#County.new({:state_fips_code => "12", :county_fips_code => "133", :name => "Washington County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "001", :name => "Appling County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "003", :name => "Atkinson County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "005", :name => "Bacon County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "007", :name => "Baker County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "009", :name => "Baldwin County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "011", :name => "Banks County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "013", :name => "Barrow County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "015", :name => "Bartow County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "017", :name => "Ben Hill County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "019", :name => "Berrien County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "021", :name => "Bibb County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "023", :name => "Bleckley County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "025", :name => "Brantley County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "027", :name => "Brooks County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "029", :name => "Bryan County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "031", :name => "Bulloch County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "033", :name => "Burke County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "035", :name => "Butts County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "037", :name => "Calhoun County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "039", :name => "Camden County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "043", :name => "Candler County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "045", :name => "Carroll County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "047", :name => "Catoosa County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "049", :name => "Charlton County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "051", :name => "Chatham County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "053", :name => "Chattahoochee County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "055", :name => "Chattooga County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "057", :name => "Cherokee County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "059", :name => "Clarke County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "061", :name => "Clay County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "063", :name => "Clayton County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "065", :name => "Clinch County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "067", :name => "Cobb County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "069", :name => "Coffee County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "071", :name => "Colquitt County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "073", :name => "Columbia County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "075", :name => "Cook County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "077", :name => "Coweta County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "079", :name => "Crawford County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "081", :name => "Crisp County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "083", :name => "Dade County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "085", :name => "Dawson County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "087", :name => "Decatur County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "089", :name => "DeKalb County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "091", :name => "Dodge County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "093", :name => "Dooly County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "095", :name => "Dougherty County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "097", :name => "Douglas County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "099", :name => "Early County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "101", :name => "Echols County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "103", :name => "Effingham County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "105", :name => "Elbert County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "107", :name => "Emanuel County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "109", :name => "Evans County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "111", :name => "Fannin County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "113", :name => "Fayette County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "115", :name => "Floyd County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "117", :name => "Forsyth County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "119", :name => "Franklin County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "121", :name => "Fulton County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "123", :name => "Gilmer County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "125", :name => "Glascock County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "127", :name => "Glynn County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "129", :name => "Gordon County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "131", :name => "Grady County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "133", :name => "Greene County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "135", :name => "Gwinnett County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "137", :name => "Habersham County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "139", :name => "Hall County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "141", :name => "Hancock County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "143", :name => "Haralson County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "145", :name => "Harris County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "147", :name => "Hart County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "149", :name => "Heard County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "151", :name => "Henry County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "153", :name => "Houston County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "155", :name => "Irwin County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "157", :name => "Jackson County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "159", :name => "Jasper County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "161", :name => "Jeff Davis County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "163", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "165", :name => "Jenkins County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "167", :name => "Johnson County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "169", :name => "Jones County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "171", :name => "Lamar County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "173", :name => "Lanier County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "175", :name => "Laurens County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "177", :name => "Lee County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "179", :name => "Liberty County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "181", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "183", :name => "Long County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "185", :name => "Lowndes County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "187", :name => "Lumpkin County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "189", :name => "McDuffie County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "191", :name => "McIntosh County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "193", :name => "Macon County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "195", :name => "Madison County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "197", :name => "Marion County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "199", :name => "Meriwether County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "201", :name => "Miller County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "205", :name => "Mitchell County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "207", :name => "Monroe County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "209", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "211", :name => "Morgan County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "213", :name => "Murray County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "215", :name => "Muscogee County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "217", :name => "Newton County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "219", :name => "Oconee County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "221", :name => "Oglethorpe County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "223", :name => "Paulding County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "225", :name => "Peach County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "227", :name => "Pickens County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "229", :name => "Pierce County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "231", :name => "Pike County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "233", :name => "Polk County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "235", :name => "Pulaski County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "237", :name => "Putnam County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "239", :name => "Quitman County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "241", :name => "Rabun County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "243", :name => "Randolph County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "245", :name => "Richmond County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "247", :name => "Rockdale County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "249", :name => "Schley County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "251", :name => "Screven County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "253", :name => "Seminole County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "255", :name => "Spalding County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "257", :name => "Stephens County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "259", :name => "Stewart County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "261", :name => "Sumter County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "263", :name => "Talbot County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "265", :name => "Taliaferro County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "267", :name => "Tattnall County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "269", :name => "Taylor County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "271", :name => "Telfair County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "273", :name => "Terrell County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "275", :name => "Thomas County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "277", :name => "Tift County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "279", :name => "Toombs County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "281", :name => "Towns County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "283", :name => "Treutlen County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "285", :name => "Troup County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "287", :name => "Turner County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "289", :name => "Twiggs County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "291", :name => "Union County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "293", :name => "Upson County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "295", :name => "Walker County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "297", :name => "Walton County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "299", :name => "Ware County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "301", :name => "Warren County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "303", :name => "Washington County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "305", :name => "Wayne County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "307", :name => "Webster County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "309", :name => "Wheeler County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "311", :name => "White County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "313", :name => "Whitfield County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "315", :name => "Wilcox County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "317", :name => "Wilkes County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "319", :name => "Wilkinson County"}).save
#County.new({:state_fips_code => "13", :county_fips_code => "321", :name => "Worth County"}).save
#County.new({:state_fips_code => "15", :county_fips_code => "001", :name => "Hawaii County"}).save
#County.new({:state_fips_code => "15", :county_fips_code => "003", :name => "Honolulu County"}).save
#County.new({:state_fips_code => "15", :county_fips_code => "005", :name => "Kalawao County"}).save
#County.new({:state_fips_code => "15", :county_fips_code => "007", :name => "Kauai County"}).save
#County.new({:state_fips_code => "15", :county_fips_code => "009", :name => "Maui County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "001", :name => "Adair County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "003", :name => "Adams County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "005", :name => "Allamakee County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "007", :name => "Appanoose County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "009", :name => "Audubon County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "011", :name => "Benton County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "013", :name => "Black Hawk County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "015", :name => "Boone County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "017", :name => "Bremer County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "019", :name => "Buchanan County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "021", :name => "Buena Vista County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "023", :name => "Butler County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "025", :name => "Calhoun County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "027", :name => "Carroll County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "029", :name => "Cass County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "031", :name => "Cedar County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "033", :name => "Cerro Gordo County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "035", :name => "Cherokee County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "037", :name => "Chickasaw County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "039", :name => "Clarke County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "041", :name => "Clay County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "043", :name => "Clayton County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "045", :name => "Clinton County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "047", :name => "Crawford County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "049", :name => "Dallas County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "051", :name => "Davis County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "053", :name => "Decatur County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "055", :name => "Delaware County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "057", :name => "Des Moines County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "059", :name => "Dickinson County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "061", :name => "Dubuque County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "063", :name => "Emmet County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "065", :name => "Fayette County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "067", :name => "Floyd County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "069", :name => "Franklin County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "071", :name => "Fremont County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "073", :name => "Greene County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "075", :name => "Grundy County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "077", :name => "Guthrie County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "079", :name => "Hamilton County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "081", :name => "Hancock County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "083", :name => "Hardin County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "085", :name => "Harrison County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "087", :name => "Henry County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "089", :name => "Howard County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "091", :name => "Humboldt County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "093", :name => "Ida County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "095", :name => "Iowa County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "097", :name => "Jackson County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "099", :name => "Jasper County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "101", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "103", :name => "Johnson County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "105", :name => "Jones County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "107", :name => "Keokuk County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "109", :name => "Kossuth County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "111", :name => "Lee County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "113", :name => "Linn County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "115", :name => "Louisa County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "117", :name => "Lucas County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "119", :name => "Lyon County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "121", :name => "Madison County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "123", :name => "Mahaska County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "125", :name => "Marion County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "127", :name => "Marshall County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "129", :name => "Mills County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "131", :name => "Mitchell County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "133", :name => "Monona County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "135", :name => "Monroe County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "137", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "139", :name => "Muscatine County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "141", :name => "O'Brien County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "143", :name => "Osceola County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "145", :name => "Page County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "147", :name => "Palo Alto County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "149", :name => "Plymouth County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "151", :name => "Pocahontas County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "153", :name => "Polk County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "155", :name => "Pottawattamie County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "157", :name => "Poweshiek County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "159", :name => "Ringgold County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "161", :name => "Sac County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "163", :name => "Scott County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "165", :name => "Shelby County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "167", :name => "Sioux County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "169", :name => "Story County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "171", :name => "Tama County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "173", :name => "Taylor County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "175", :name => "Union County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "177", :name => "Van Buren County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "179", :name => "Wapello County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "181", :name => "Warren County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "183", :name => "Washington County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "185", :name => "Wayne County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "187", :name => "Webster County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "189", :name => "Winnebago County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "191", :name => "Winneshiek County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "193", :name => "Woodbury County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "195", :name => "Worth County"}).save
#County.new({:state_fips_code => "19", :county_fips_code => "197", :name => "Wright County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "001", :name => "Ada County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "003", :name => "Adams County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "005", :name => "Bannock County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "007", :name => "Bear Lake County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "009", :name => "Benewah County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "011", :name => "Bingham County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "013", :name => "Blaine County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "015", :name => "Boise County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "017", :name => "Bonner County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "019", :name => "Bonneville County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "021", :name => "Boundary County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "023", :name => "Butte County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "025", :name => "Camas County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "027", :name => "Canyon County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "029", :name => "Caribou County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "031", :name => "Cassia County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "033", :name => "Clark County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "035", :name => "Clearwater County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "037", :name => "Custer County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "039", :name => "Elmore County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "041", :name => "Franklin County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "043", :name => "Fremont County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "045", :name => "Gem County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "047", :name => "Gooding County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "049", :name => "Idaho County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "051", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "053", :name => "Jerome County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "055", :name => "Kootenai County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "057", :name => "Latah County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "059", :name => "Lemhi County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "061", :name => "Lewis County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "063", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "065", :name => "Madison County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "067", :name => "Minidoka County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "069", :name => "Nez Perce County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "071", :name => "Oneida County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "073", :name => "Owyhee County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "075", :name => "Payette County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "077", :name => "Power County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "079", :name => "Shoshone County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "081", :name => "Teton County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "083", :name => "Twin Falls County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "085", :name => "Valley County"}).save
#County.new({:state_fips_code => "16", :county_fips_code => "087", :name => "Washington County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "001", :name => "Adams County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "003", :name => "Alexander County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "005", :name => "Bond County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "007", :name => "Boone County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "009", :name => "Brown County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "011", :name => "Bureau County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "013", :name => "Calhoun County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "015", :name => "Carroll County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "017", :name => "Cass County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "019", :name => "Champaign County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "021", :name => "Christian County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "023", :name => "Clark County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "025", :name => "Clay County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "027", :name => "Clinton County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "029", :name => "Coles County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "031", :name => "Cook County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "033", :name => "Crawford County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "035", :name => "Cumberland County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "037", :name => "DeKalb County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "039", :name => "De Witt County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "041", :name => "Douglas County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "043", :name => "DuPage County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "045", :name => "Edgar County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "047", :name => "Edwards County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "049", :name => "Effingham County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "051", :name => "Fayette County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "053", :name => "Ford County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "055", :name => "Franklin County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "057", :name => "Fulton County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "059", :name => "Gallatin County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "061", :name => "Greene County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "063", :name => "Grundy County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "065", :name => "Hamilton County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "067", :name => "Hancock County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "069", :name => "Hardin County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "071", :name => "Henderson County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "073", :name => "Henry County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "075", :name => "Iroquois County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "077", :name => "Jackson County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "079", :name => "Jasper County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "081", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "083", :name => "Jersey County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "085", :name => "Jo Daviess County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "087", :name => "Johnson County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "089", :name => "Kane County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "091", :name => "Kankakee County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "093", :name => "Kendall County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "095", :name => "Knox County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "097", :name => "Lake County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "099", :name => "La Salle County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "101", :name => "Lawrence County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "103", :name => "Lee County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "105", :name => "Livingston County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "107", :name => "Logan County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "109", :name => "McDonough County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "111", :name => "McHenry County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "113", :name => "McLean County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "115", :name => "Macon County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "117", :name => "Macoupin County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "119", :name => "Madison County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "121", :name => "Marion County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "123", :name => "Marshall County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "125", :name => "Mason County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "127", :name => "Massac County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "129", :name => "Menard County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "131", :name => "Mercer County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "133", :name => "Monroe County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "135", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "137", :name => "Morgan County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "139", :name => "Moultrie County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "141", :name => "Ogle County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "143", :name => "Peoria County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "145", :name => "Perry County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "147", :name => "Piatt County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "149", :name => "Pike County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "151", :name => "Pope County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "153", :name => "Pulaski County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "155", :name => "Putnam County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "157", :name => "Randolph County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "159", :name => "Richland County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "161", :name => "Rock Island County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "163", :name => "St. Clair County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "165", :name => "Saline County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "167", :name => "Sangamon County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "169", :name => "Schuyler County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "171", :name => "Scott County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "173", :name => "Shelby County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "175", :name => "Stark County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "177", :name => "Stephenson County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "179", :name => "Tazewell County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "181", :name => "Union County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "183", :name => "Vermilion County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "185", :name => "Wabash County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "187", :name => "Warren County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "189", :name => "Washington County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "191", :name => "Wayne County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "193", :name => "White County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "195", :name => "Whiteside County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "197", :name => "Will County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "199", :name => "Williamson County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "201", :name => "Winnebago County"}).save
#County.new({:state_fips_code => "17", :county_fips_code => "203", :name => "Woodford County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "001", :name => "Adams County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "003", :name => "Allen County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "005", :name => "Bartholomew County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "007", :name => "Benton County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "009", :name => "Blackford County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "011", :name => "Boone County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "013", :name => "Brown County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "015", :name => "Carroll County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "017", :name => "Cass County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "019", :name => "Clark County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "021", :name => "Clay County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "023", :name => "Clinton County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "025", :name => "Crawford County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "027", :name => "Daviess County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "029", :name => "Dearborn County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "031", :name => "Decatur County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "033", :name => "De Kalb County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "035", :name => "Delaware County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "037", :name => "Dubois County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "039", :name => "Elkhart County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "041", :name => "Fayette County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "043", :name => "Floyd County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "045", :name => "Fountain County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "047", :name => "Franklin County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "049", :name => "Fulton County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "051", :name => "Gibson County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "053", :name => "Grant County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "055", :name => "Greene County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "057", :name => "Hamilton County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "059", :name => "Hancock County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "061", :name => "Harrison County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "063", :name => "Hendricks County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "065", :name => "Henry County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "067", :name => "Howard County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "069", :name => "Huntington County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "071", :name => "Jackson County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "073", :name => "Jasper County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "075", :name => "Jay County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "077", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "079", :name => "Jennings County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "081", :name => "Johnson County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "083", :name => "Knox County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "085", :name => "Kosciusko County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "087", :name => "Lagrange County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "089", :name => "Lake County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "091", :name => "La Porte County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "093", :name => "Lawrence County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "095", :name => "Madison County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "097", :name => "Marion County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "099", :name => "Marshall County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "101", :name => "Martin County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "103", :name => "Miami County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "105", :name => "Monroe County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "107", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "109", :name => "Morgan County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "111", :name => "Newton County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "113", :name => "Noble County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "115", :name => "Ohio County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "117", :name => "Orange County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "119", :name => "Owen County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "121", :name => "Parke County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "123", :name => "Perry County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "125", :name => "Pike County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "127", :name => "Porter County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "129", :name => "Posey County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "131", :name => "Pulaski County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "133", :name => "Putnam County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "135", :name => "Randolph County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "137", :name => "Ripley County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "139", :name => "Rush County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "141", :name => "St. Joseph County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "143", :name => "Scott County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "145", :name => "Shelby County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "147", :name => "Spencer County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "149", :name => "Starke County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "151", :name => "Steuben County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "153", :name => "Sullivan County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "155", :name => "Switzerland County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "157", :name => "Tippecanoe County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "159", :name => "Tipton County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "161", :name => "Union County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "163", :name => "Vanderburgh County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "165", :name => "Vermillion County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "167", :name => "Vigo County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "169", :name => "Wabash County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "171", :name => "Warren County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "173", :name => "Warrick County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "175", :name => "Washington County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "177", :name => "Wayne County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "179", :name => "Wells County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "181", :name => "White County"}).save
#County.new({:state_fips_code => "18", :county_fips_code => "183", :name => "Whitley County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "001", :name => "Allen County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "003", :name => "Anderson County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "005", :name => "Atchison County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "007", :name => "Barber County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "009", :name => "Barton County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "011", :name => "Bourbon County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "013", :name => "Brown County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "015", :name => "Butler County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "017", :name => "Chase County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "019", :name => "Chautauqua County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "021", :name => "Cherokee County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "023", :name => "Cheyenne County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "025", :name => "Clark County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "027", :name => "Clay County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "029", :name => "Cloud County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "031", :name => "Coffey County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "033", :name => "Comanche County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "035", :name => "Cowley County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "037", :name => "Crawford County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "039", :name => "Decatur County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "041", :name => "Dickinson County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "043", :name => "Doniphan County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "045", :name => "Douglas County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "047", :name => "Edwards County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "049", :name => "Elk County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "051", :name => "Ellis County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "053", :name => "Ellsworth County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "055", :name => "Finney County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "057", :name => "Ford County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "059", :name => "Franklin County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "061", :name => "Geary County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "063", :name => "Gove County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "065", :name => "Graham County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "067", :name => "Grant County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "069", :name => "Gray County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "071", :name => "Greeley County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "073", :name => "Greenwood County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "075", :name => "Hamilton County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "077", :name => "Harper County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "079", :name => "Harvey County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "081", :name => "Haskell County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "083", :name => "Hodgeman County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "085", :name => "Jackson County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "087", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "089", :name => "Jewell County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "091", :name => "Johnson County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "093", :name => "Kearny County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "095", :name => "Kingman County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "097", :name => "Kiowa County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "099", :name => "Labette County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "101", :name => "Lane County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "103", :name => "Leavenworth County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "105", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "107", :name => "Linn County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "109", :name => "Logan County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "111", :name => "Lyon County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "113", :name => "McPherson County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "115", :name => "Marion County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "117", :name => "Marshall County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "119", :name => "Meade County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "121", :name => "Miami County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "123", :name => "Mitchell County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "125", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "127", :name => "Morris County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "129", :name => "Morton County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "131", :name => "Nemaha County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "133", :name => "Neosho County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "135", :name => "Ness County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "137", :name => "Norton County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "139", :name => "Osage County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "141", :name => "Osborne County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "143", :name => "Ottawa County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "145", :name => "Pawnee County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "147", :name => "Phillips County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "149", :name => "Pottawatomie County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "151", :name => "Pratt County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "153", :name => "Rawlins County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "155", :name => "Reno County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "157", :name => "Republic County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "159", :name => "Rice County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "161", :name => "Riley County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "163", :name => "Rooks County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "165", :name => "Rush County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "167", :name => "Russell County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "169", :name => "Saline County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "171", :name => "Scott County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "173", :name => "Sedgwick County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "175", :name => "Seward County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "177", :name => "Shawnee County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "179", :name => "Sheridan County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "181", :name => "Sherman County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "183", :name => "Smith County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "185", :name => "Stafford County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "187", :name => "Stanton County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "189", :name => "Stevens County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "191", :name => "Sumner County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "193", :name => "Thomas County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "195", :name => "Trego County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "197", :name => "Wabaunsee County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "199", :name => "Wallace County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "201", :name => "Washington County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "203", :name => "Wichita County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "205", :name => "Wilson County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "207", :name => "Woodson County"}).save
#County.new({:state_fips_code => "20", :county_fips_code => "209", :name => "Wyandotte County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "001", :name => "Adair County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "003", :name => "Allen County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "005", :name => "Anderson County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "007", :name => "Ballard County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "009", :name => "Barren County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "011", :name => "Bath County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "013", :name => "Bell County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "015", :name => "Boone County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "017", :name => "Bourbon County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "019", :name => "Boyd County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "021", :name => "Boyle County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "023", :name => "Bracken County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "025", :name => "Breathitt County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "027", :name => "Breckinridge County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "029", :name => "Bullitt County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "031", :name => "Butler County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "033", :name => "Caldwell County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "035", :name => "Calloway County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "037", :name => "Campbell County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "039", :name => "Carlisle County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "041", :name => "Carroll County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "043", :name => "Carter County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "045", :name => "Casey County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "047", :name => "Christian County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "049", :name => "Clark County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "051", :name => "Clay County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "053", :name => "Clinton County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "055", :name => "Crittenden County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "057", :name => "Cumberland County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "059", :name => "Daviess County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "061", :name => "Edmonson County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "063", :name => "Elliott County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "065", :name => "Estill County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "067", :name => "Fayette County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "069", :name => "Fleming County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "071", :name => "Floyd County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "073", :name => "Franklin County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "075", :name => "Fulton County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "077", :name => "Gallatin County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "079", :name => "Garrard County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "081", :name => "Grant County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "083", :name => "Graves County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "085", :name => "Grayson County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "087", :name => "Green County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "089", :name => "Greenup County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "091", :name => "Hancock County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "093", :name => "Hardin County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "095", :name => "Harlan County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "097", :name => "Harrison County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "099", :name => "Hart County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "101", :name => "Henderson County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "103", :name => "Henry County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "105", :name => "Hickman County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "107", :name => "Hopkins County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "109", :name => "Jackson County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "111", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "113", :name => "Jessamine County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "115", :name => "Johnson County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "117", :name => "Kenton County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "119", :name => "Knott County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "121", :name => "Knox County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "123", :name => "Larue County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "125", :name => "Laurel County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "127", :name => "Lawrence County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "129", :name => "Lee County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "131", :name => "Leslie County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "133", :name => "Letcher County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "135", :name => "Lewis County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "137", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "139", :name => "Livingston County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "141", :name => "Logan County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "143", :name => "Lyon County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "145", :name => "McCracken County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "147", :name => "McCreary County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "149", :name => "McLean County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "151", :name => "Madison County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "153", :name => "Magoffin County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "155", :name => "Marion County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "157", :name => "Marshall County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "159", :name => "Martin County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "161", :name => "Mason County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "163", :name => "Meade County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "165", :name => "Menifee County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "167", :name => "Mercer County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "169", :name => "Metcalfe County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "171", :name => "Monroe County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "173", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "175", :name => "Morgan County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "177", :name => "Muhlenberg County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "179", :name => "Nelson County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "181", :name => "Nicholas County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "183", :name => "Ohio County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "185", :name => "Oldham County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "187", :name => "Owen County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "189", :name => "Owsley County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "191", :name => "Pendleton County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "193", :name => "Perry County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "195", :name => "Pike County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "197", :name => "Powell County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "199", :name => "Pulaski County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "201", :name => "Robertson County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "203", :name => "Rockcastle County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "205", :name => "Rowan County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "207", :name => "Russell County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "209", :name => "Scott County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "211", :name => "Shelby County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "213", :name => "Simpson County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "215", :name => "Spencer County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "217", :name => "Taylor County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "219", :name => "Todd County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "221", :name => "Trigg County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "223", :name => "Trimble County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "225", :name => "Union County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "227", :name => "Warren County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "229", :name => "Washington County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "231", :name => "Wayne County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "233", :name => "Webster County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "235", :name => "Whitley County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "237", :name => "Wolfe County"}).save
#County.new({:state_fips_code => "21", :county_fips_code => "239", :name => "Woodford County"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "001", :name => "Acadia Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "003", :name => "Allen Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "005", :name => "Ascension Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "007", :name => "Assumption Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "009", :name => "Avoyelles Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "011", :name => "Beauregard Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "013", :name => "Bienville Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "015", :name => "Bossier Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "017", :name => "Caddo Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "019", :name => "Calcasieu Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "021", :name => "Caldwell Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "023", :name => "Cameron Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "025", :name => "Catahoula Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "027", :name => "Claiborne Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "029", :name => "Concordia Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "031", :name => "De Soto Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "033", :name => "East Baton Rouge Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "035", :name => "East Carroll Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "037", :name => "East Feliciana Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "039", :name => "Evangeline Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "041", :name => "Franklin Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "043", :name => "Grant Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "045", :name => "Iberia Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "047", :name => "Iberville Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "049", :name => "Jackson Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "051", :name => "Jefferson Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "053", :name => "Jefferson Davis Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "055", :name => "Lafayette Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "057", :name => "Lafourche Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "059", :name => "La Salle Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "061", :name => "Lincoln Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "063", :name => "Livingston Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "065", :name => "Madison Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "067", :name => "Morehouse Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "069", :name => "Natchitoches Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "071", :name => "Orleans Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "073", :name => "Ouachita Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "075", :name => "Plaquemines Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "077", :name => "Pointe Coupee Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "079", :name => "Rapides Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "081", :name => "Red River Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "083", :name => "Richland Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "085", :name => "Sabine Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "087", :name => "St. Bernard Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "089", :name => "St. Charles Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "091", :name => "St. Helena Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "093", :name => "St. James Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "095", :name => "St. John the Baptist Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "097", :name => "St. Landry Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "099", :name => "St. Martin Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "101", :name => "St. Mary Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "103", :name => "St. Tammany Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "105", :name => "Tangipahoa Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "107", :name => "Tensas Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "109", :name => "Terrebonne Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "111", :name => "Union Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "113", :name => "Vermilion Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "115", :name => "Vernon Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "117", :name => "Washington Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "119", :name => "Webster Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "121", :name => "West Baton Rouge Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "123", :name => "West Carroll Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "125", :name => "West Feliciana Parish"}).save
#County.new({:state_fips_code => "22", :county_fips_code => "127", :name => "Winn Parish"}).save
#County.new({:state_fips_code => "25", :county_fips_code => "001", :name => "Barnstable County"}).save
#County.new({:state_fips_code => "25", :county_fips_code => "003", :name => "Berkshire County"}).save
#County.new({:state_fips_code => "25", :county_fips_code => "005", :name => "Bristol County"}).save
#County.new({:state_fips_code => "25", :county_fips_code => "007", :name => "Dukes County"}).save
#County.new({:state_fips_code => "25", :county_fips_code => "009", :name => "Essex County"}).save
#County.new({:state_fips_code => "25", :county_fips_code => "011", :name => "Franklin County"}).save
#County.new({:state_fips_code => "25", :county_fips_code => "013", :name => "Hampden County"}).save
#County.new({:state_fips_code => "25", :county_fips_code => "015", :name => "Hampshire County"}).save
#County.new({:state_fips_code => "25", :county_fips_code => "017", :name => "Middlesex County"}).save
#County.new({:state_fips_code => "25", :county_fips_code => "019", :name => "Nantucket County"}).save
#County.new({:state_fips_code => "25", :county_fips_code => "021", :name => "Norfolk County"}).save
#County.new({:state_fips_code => "25", :county_fips_code => "023", :name => "Plymouth County"}).save
#County.new({:state_fips_code => "25", :county_fips_code => "025", :name => "Suffolk County"}).save
#County.new({:state_fips_code => "25", :county_fips_code => "027", :name => "Worcester County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "001", :name => "Allegany County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "003", :name => "Anne Arundel County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "005", :name => "Baltimore County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "009", :name => "Calvert County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "011", :name => "Caroline County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "013", :name => "Carroll County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "015", :name => "Cecil County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "017", :name => "Charles County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "019", :name => "Dorchester County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "021", :name => "Frederick County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "023", :name => "Garrett County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "025", :name => "Harford County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "027", :name => "Howard County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "029", :name => "Kent County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "031", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "033", :name => "Prince George's County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "035", :name => "Queen Anne's County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "037", :name => "St. Mary's County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "039", :name => "Somerset County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "041", :name => "Talbot County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "043", :name => "Washington County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "045", :name => "Wicomico County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "047", :name => "Worcester County"}).save
#County.new({:state_fips_code => "24", :county_fips_code => "510", :name => "Baltimore city"}).save
#County.new({:state_fips_code => "23", :county_fips_code => "001", :name => "Androscoggin County"}).save
#County.new({:state_fips_code => "23", :county_fips_code => "003", :name => "Aroostook County"}).save
#County.new({:state_fips_code => "23", :county_fips_code => "005", :name => "Cumberland County"}).save
#County.new({:state_fips_code => "23", :county_fips_code => "007", :name => "Franklin County"}).save
#County.new({:state_fips_code => "23", :county_fips_code => "009", :name => "Hancock County"}).save
#County.new({:state_fips_code => "23", :county_fips_code => "011", :name => "Kennebec County"}).save
#County.new({:state_fips_code => "23", :county_fips_code => "013", :name => "Knox County"}).save
#County.new({:state_fips_code => "23", :county_fips_code => "015", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "23", :county_fips_code => "017", :name => "Oxford County"}).save
#County.new({:state_fips_code => "23", :county_fips_code => "019", :name => "Penobscot County"}).save
#County.new({:state_fips_code => "23", :county_fips_code => "021", :name => "Piscataquis County"}).save
#County.new({:state_fips_code => "23", :county_fips_code => "023", :name => "Sagadahoc County"}).save
#County.new({:state_fips_code => "23", :county_fips_code => "025", :name => "Somerset County"}).save
#County.new({:state_fips_code => "23", :county_fips_code => "027", :name => "Waldo County"}).save
#County.new({:state_fips_code => "23", :county_fips_code => "029", :name => "Washington County"}).save
#County.new({:state_fips_code => "23", :county_fips_code => "031", :name => "York County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "001", :name => "Alcona County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "003", :name => "Alger County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "005", :name => "Allegan County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "007", :name => "Alpena County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "009", :name => "Antrim County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "011", :name => "Arenac County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "013", :name => "Baraga County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "015", :name => "Barry County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "017", :name => "Bay County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "019", :name => "Benzie County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "021", :name => "Berrien County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "023", :name => "Branch County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "025", :name => "Calhoun County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "027", :name => "Cass County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "029", :name => "Charlevoix County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "031", :name => "Cheboygan County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "033", :name => "Chippewa County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "035", :name => "Clare County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "037", :name => "Clinton County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "039", :name => "Crawford County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "041", :name => "Delta County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "043", :name => "Dickinson County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "045", :name => "Eaton County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "047", :name => "Emmet County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "049", :name => "Genesee County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "051", :name => "Gladwin County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "053", :name => "Gogebic County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "055", :name => "Grand Traverse County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "057", :name => "Gratiot County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "059", :name => "Hillsdale County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "061", :name => "Houghton County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "063", :name => "Huron County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "065", :name => "Ingham County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "067", :name => "Ionia County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "069", :name => "Iosco County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "071", :name => "Iron County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "073", :name => "Isabella County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "075", :name => "Jackson County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "077", :name => "Kalamazoo County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "079", :name => "Kalkaska County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "081", :name => "Kent County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "083", :name => "Keweenaw County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "085", :name => "Lake County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "087", :name => "Lapeer County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "089", :name => "Leelanau County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "091", :name => "Lenawee County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "093", :name => "Livingston County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "095", :name => "Luce County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "097", :name => "Mackinac County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "099", :name => "Macomb County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "101", :name => "Manistee County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "103", :name => "Marquette County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "105", :name => "Mason County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "107", :name => "Mecosta County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "109", :name => "Menominee County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "111", :name => "Midland County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "113", :name => "Missaukee County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "115", :name => "Monroe County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "117", :name => "Montcalm County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "119", :name => "Montmorency County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "121", :name => "Muskegon County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "123", :name => "Newaygo County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "125", :name => "Oakland County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "127", :name => "Oceana County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "129", :name => "Ogemaw County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "131", :name => "Ontonagon County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "133", :name => "Osceola County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "135", :name => "Oscoda County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "137", :name => "Otsego County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "139", :name => "Ottawa County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "141", :name => "Presque Isle County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "143", :name => "Roscommon County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "145", :name => "Saginaw County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "147", :name => "St. Clair County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "149", :name => "St. Joseph County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "151", :name => "Sanilac County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "153", :name => "Schoolcraft County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "155", :name => "Shiawassee County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "157", :name => "Tuscola County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "159", :name => "Van Buren County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "161", :name => "Washtenaw County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "163", :name => "Wayne County"}).save
#County.new({:state_fips_code => "26", :county_fips_code => "165", :name => "Wexford County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "001", :name => "Aitkin County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "003", :name => "Anoka County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "005", :name => "Becker County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "007", :name => "Beltrami County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "009", :name => "Benton County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "011", :name => "Big Stone County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "013", :name => "Blue Earth County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "015", :name => "Brown County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "017", :name => "Carlton County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "019", :name => "Carver County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "021", :name => "Cass County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "023", :name => "Chippewa County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "025", :name => "Chisago County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "027", :name => "Clay County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "029", :name => "Clearwater County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "031", :name => "Cook County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "033", :name => "Cottonwood County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "035", :name => "Crow Wing County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "037", :name => "Dakota County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "039", :name => "Dodge County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "041", :name => "Douglas County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "043", :name => "Faribault County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "045", :name => "Fillmore County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "047", :name => "Freeborn County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "049", :name => "Goodhue County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "051", :name => "Grant County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "053", :name => "Hennepin County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "055", :name => "Houston County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "057", :name => "Hubbard County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "059", :name => "Isanti County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "061", :name => "Itasca County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "063", :name => "Jackson County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "065", :name => "Kanabec County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "067", :name => "Kandiyohi County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "069", :name => "Kittson County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "071", :name => "Koochiching County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "073", :name => "Lac qui Parle County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "075", :name => "Lake County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "077", :name => "Lake of the Woods County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "079", :name => "Le Sueur County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "081", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "083", :name => "Lyon County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "085", :name => "McLeod County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "087", :name => "Mahnomen County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "089", :name => "Marshall County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "091", :name => "Martin County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "093", :name => "Meeker County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "095", :name => "Mille Lacs County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "097", :name => "Morrison County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "099", :name => "Mower County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "101", :name => "Murray County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "103", :name => "Nicollet County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "105", :name => "Nobles County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "107", :name => "Norman County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "109", :name => "Olmsted County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "111", :name => "Otter Tail County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "113", :name => "Pennington County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "115", :name => "Pine County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "117", :name => "Pipestone County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "119", :name => "Polk County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "121", :name => "Pope County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "123", :name => "Ramsey County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "125", :name => "Red Lake County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "127", :name => "Redwood County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "129", :name => "Renville County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "131", :name => "Rice County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "133", :name => "Rock County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "135", :name => "Roseau County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "137", :name => "St. Louis County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "139", :name => "Scott County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "141", :name => "Sherburne County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "143", :name => "Sibley County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "145", :name => "Stearns County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "147", :name => "Steele County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "149", :name => "Stevens County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "151", :name => "Swift County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "153", :name => "Todd County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "155", :name => "Traverse County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "157", :name => "Wabasha County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "159", :name => "Wadena County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "161", :name => "Waseca County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "163", :name => "Washington County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "165", :name => "Watonwan County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "167", :name => "Wilkin County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "169", :name => "Winona County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "171", :name => "Wright County"}).save
#County.new({:state_fips_code => "27", :county_fips_code => "173", :name => "Yellow Medicine County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "001", :name => "Adair County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "003", :name => "Andrew County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "005", :name => "Atchison County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "007", :name => "Audrain County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "009", :name => "Barry County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "011", :name => "Barton County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "013", :name => "Bates County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "015", :name => "Benton County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "017", :name => "Bollinger County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "019", :name => "Boone County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "021", :name => "Buchanan County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "023", :name => "Butler County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "025", :name => "Caldwell County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "027", :name => "Callaway County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "029", :name => "Camden County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "031", :name => "Cape Girardeau County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "033", :name => "Carroll County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "035", :name => "Carter County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "037", :name => "Cass County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "039", :name => "Cedar County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "041", :name => "Chariton County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "043", :name => "Christian County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "045", :name => "Clark County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "047", :name => "Clay County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "049", :name => "Clinton County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "051", :name => "Cole County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "053", :name => "Cooper County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "055", :name => "Crawford County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "057", :name => "Dade County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "059", :name => "Dallas County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "061", :name => "Daviess County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "063", :name => "DeKalb County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "065", :name => "Dent County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "067", :name => "Douglas County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "069", :name => "Dunklin County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "071", :name => "Franklin County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "073", :name => "Gasconade County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "075", :name => "Gentry County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "077", :name => "Greene County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "079", :name => "Grundy County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "081", :name => "Harrison County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "083", :name => "Henry County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "085", :name => "Hickory County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "087", :name => "Holt County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "089", :name => "Howard County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "091", :name => "Howell County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "093", :name => "Iron County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "095", :name => "Jackson County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "097", :name => "Jasper County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "099", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "101", :name => "Johnson County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "103", :name => "Knox County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "105", :name => "Laclede County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "107", :name => "Lafayette County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "109", :name => "Lawrence County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "111", :name => "Lewis County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "113", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "115", :name => "Linn County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "117", :name => "Livingston County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "119", :name => "McDonald County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "121", :name => "Macon County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "123", :name => "Madison County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "125", :name => "Maries County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "127", :name => "Marion County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "129", :name => "Mercer County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "131", :name => "Miller County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "133", :name => "Mississippi County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "135", :name => "Moniteau County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "137", :name => "Monroe County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "139", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "141", :name => "Morgan County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "143", :name => "New Madrid County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "145", :name => "Newton County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "147", :name => "Nodaway County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "149", :name => "Oregon County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "151", :name => "Osage County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "153", :name => "Ozark County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "155", :name => "Pemiscot County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "157", :name => "Perry County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "159", :name => "Pettis County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "161", :name => "Phelps County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "163", :name => "Pike County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "165", :name => "Platte County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "167", :name => "Polk County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "169", :name => "Pulaski County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "171", :name => "Putnam County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "173", :name => "Ralls County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "175", :name => "Randolph County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "177", :name => "Ray County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "179", :name => "Reynolds County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "181", :name => "Ripley County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "183", :name => "St. Charles County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "185", :name => "St. Clair County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "186", :name => "Ste. Genevieve County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "187", :name => "St. Francois County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "189", :name => "St. Louis County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "195", :name => "Saline County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "197", :name => "Schuyler County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "199", :name => "Scotland County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "201", :name => "Scott County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "203", :name => "Shannon County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "205", :name => "Shelby County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "207", :name => "Stoddard County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "209", :name => "Stone County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "211", :name => "Sullivan County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "213", :name => "Taney County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "215", :name => "Texas County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "217", :name => "Vernon County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "219", :name => "Warren County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "221", :name => "Washington County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "223", :name => "Wayne County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "225", :name => "Webster County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "227", :name => "Worth County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "229", :name => "Wright County"}).save
#County.new({:state_fips_code => "29", :county_fips_code => "510", :name => "St. Louis city"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "001", :name => "Adams County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "003", :name => "Alcorn County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "005", :name => "Amite County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "007", :name => "Attala County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "009", :name => "Benton County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "011", :name => "Bolivar County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "013", :name => "Calhoun County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "015", :name => "Carroll County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "017", :name => "Chickasaw County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "019", :name => "Choctaw County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "021", :name => "Claiborne County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "023", :name => "Clarke County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "025", :name => "Clay County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "027", :name => "Coahoma County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "029", :name => "Copiah County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "031", :name => "Covington County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "033", :name => "DeSoto County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "035", :name => "Forrest County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "037", :name => "Franklin County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "039", :name => "George County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "041", :name => "Greene County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "043", :name => "Grenada County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "045", :name => "Hancock County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "047", :name => "Harrison County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "049", :name => "Hinds County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "051", :name => "Holmes County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "053", :name => "Humphreys County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "055", :name => "Issaquena County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "057", :name => "Itawamba County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "059", :name => "Jackson County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "061", :name => "Jasper County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "063", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "065", :name => "Jefferson Davis County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "067", :name => "Jones County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "069", :name => "Kemper County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "071", :name => "Lafayette County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "073", :name => "Lamar County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "075", :name => "Lauderdale County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "077", :name => "Lawrence County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "079", :name => "Leake County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "081", :name => "Lee County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "083", :name => "Leflore County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "085", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "087", :name => "Lowndes County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "089", :name => "Madison County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "091", :name => "Marion County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "093", :name => "Marshall County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "095", :name => "Monroe County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "097", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "099", :name => "Neshoba County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "101", :name => "Newton County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "103", :name => "Noxubee County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "105", :name => "Oktibbeha County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "107", :name => "Panola County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "109", :name => "Pearl River County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "111", :name => "Perry County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "113", :name => "Pike County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "115", :name => "Pontotoc County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "117", :name => "Prentiss County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "119", :name => "Quitman County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "121", :name => "Rankin County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "123", :name => "Scott County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "125", :name => "Sharkey County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "127", :name => "Simpson County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "129", :name => "Smith County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "131", :name => "Stone County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "133", :name => "Sunflower County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "135", :name => "Tallahatchie County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "137", :name => "Tate County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "139", :name => "Tippah County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "141", :name => "Tishomingo County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "143", :name => "Tunica County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "145", :name => "Union County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "147", :name => "Walthall County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "149", :name => "Warren County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "151", :name => "Washington County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "153", :name => "Wayne County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "155", :name => "Webster County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "157", :name => "Wilkinson County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "159", :name => "Winston County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "161", :name => "Yalobusha County"}).save
#County.new({:state_fips_code => "28", :county_fips_code => "163", :name => "Yazoo County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "001", :name => "Beaverhead County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "003", :name => "Big Horn County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "005", :name => "Blaine County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "007", :name => "Broadwater County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "009", :name => "Carbon County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "011", :name => "Carter County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "013", :name => "Cascade County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "015", :name => "Chouteau County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "017", :name => "Custer County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "019", :name => "Daniels County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "021", :name => "Dawson County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "023", :name => "Deer Lodge County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "025", :name => "Fallon County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "027", :name => "Fergus County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "029", :name => "Flathead County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "031", :name => "Gallatin County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "033", :name => "Garfield County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "035", :name => "Glacier County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "037", :name => "Golden Valley County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "039", :name => "Granite County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "041", :name => "Hill County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "043", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "045", :name => "Judith Basin County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "047", :name => "Lake County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "049", :name => "Lewis and Clark County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "051", :name => "Liberty County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "053", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "055", :name => "McCone County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "057", :name => "Madison County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "059", :name => "Meagher County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "061", :name => "Mineral County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "063", :name => "Missoula County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "065", :name => "Musselshell County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "067", :name => "Park County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "069", :name => "Petroleum County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "071", :name => "Phillips County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "073", :name => "Pondera County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "075", :name => "Powder River County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "077", :name => "Powell County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "079", :name => "Prairie County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "081", :name => "Ravalli County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "083", :name => "Richland County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "085", :name => "Roosevelt County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "087", :name => "Rosebud County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "089", :name => "Sanders County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "091", :name => "Sheridan County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "093", :name => "Silver Bow County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "095", :name => "Stillwater County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "097", :name => "Sweet Grass County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "099", :name => "Teton County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "101", :name => "Toole County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "103", :name => "Treasure County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "105", :name => "Valley County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "107", :name => "Wheatland County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "109", :name => "Wibaux County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "111", :name => "Yellowstone County"}).save
#County.new({:state_fips_code => "30", :county_fips_code => "113", :name => "Yellowstone National Park"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "001", :name => "Alamance County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "003", :name => "Alexander County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "005", :name => "Alleghany County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "007", :name => "Anson County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "009", :name => "Ashe County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "011", :name => "Avery County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "013", :name => "Beaufort County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "015", :name => "Bertie County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "017", :name => "Bladen County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "019", :name => "Brunswick County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "021", :name => "Buncombe County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "023", :name => "Burke County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "025", :name => "Cabarrus County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "027", :name => "Caldwell County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "029", :name => "Camden County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "031", :name => "Carteret County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "033", :name => "Caswell County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "035", :name => "Catawba County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "037", :name => "Chatham County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "039", :name => "Cherokee County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "041", :name => "Chowan County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "043", :name => "Clay County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "045", :name => "Cleveland County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "047", :name => "Columbus County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "049", :name => "Craven County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "051", :name => "Cumberland County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "053", :name => "Currituck County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "055", :name => "Dare County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "057", :name => "Davidson County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "059", :name => "Davie County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "061", :name => "Duplin County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "063", :name => "Durham County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "065", :name => "Edgecombe County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "067", :name => "Forsyth County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "069", :name => "Franklin County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "071", :name => "Gaston County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "073", :name => "Gates County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "075", :name => "Graham County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "077", :name => "Granville County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "079", :name => "Greene County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "081", :name => "Guilford County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "083", :name => "Halifax County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "085", :name => "Harnett County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "087", :name => "Haywood County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "089", :name => "Henderson County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "091", :name => "Hertford County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "093", :name => "Hoke County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "095", :name => "Hyde County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "097", :name => "Iredell County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "099", :name => "Jackson County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "101", :name => "Johnston County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "103", :name => "Jones County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "105", :name => "Lee County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "107", :name => "Lenoir County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "109", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "111", :name => "McDowell County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "113", :name => "Macon County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "115", :name => "Madison County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "117", :name => "Martin County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "119", :name => "Mecklenburg County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "121", :name => "Mitchell County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "123", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "125", :name => "Moore County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "127", :name => "Nash County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "129", :name => "New Hanover County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "131", :name => "Northampton County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "133", :name => "Onslow County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "135", :name => "Orange County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "137", :name => "Pamlico County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "139", :name => "Pasquotank County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "141", :name => "Pender County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "143", :name => "Perquimans County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "145", :name => "Person County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "147", :name => "Pitt County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "149", :name => "Polk County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "151", :name => "Randolph County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "153", :name => "Richmond County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "155", :name => "Robeson County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "157", :name => "Rockingham County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "159", :name => "Rowan County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "161", :name => "Rutherford County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "163", :name => "Sampson County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "165", :name => "Scotland County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "167", :name => "Stanly County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "169", :name => "Stokes County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "171", :name => "Surry County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "173", :name => "Swain County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "175", :name => "Transylvania County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "177", :name => "Tyrrell County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "179", :name => "Union County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "181", :name => "Vance County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "183", :name => "Wake County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "185", :name => "Warren County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "187", :name => "Washington County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "189", :name => "Watauga County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "191", :name => "Wayne County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "193", :name => "Wilkes County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "195", :name => "Wilson County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "197", :name => "Yadkin County"}).save
#County.new({:state_fips_code => "37", :county_fips_code => "199", :name => "Yancey County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "001", :name => "Adams County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "003", :name => "Barnes County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "005", :name => "Benson County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "007", :name => "Billings County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "009", :name => "Bottineau County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "011", :name => "Bowman County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "013", :name => "Burke County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "015", :name => "Burleigh County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "017", :name => "Cass County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "019", :name => "Cavalier County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "021", :name => "Dickey County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "023", :name => "Divide County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "025", :name => "Dunn County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "027", :name => "Eddy County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "029", :name => "Emmons County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "031", :name => "Foster County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "033", :name => "Golden Valley County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "035", :name => "Grand Forks County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "037", :name => "Grant County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "039", :name => "Griggs County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "041", :name => "Hettinger County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "043", :name => "Kidder County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "045", :name => "LaMoure County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "047", :name => "Logan County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "049", :name => "McHenry County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "051", :name => "McIntosh County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "053", :name => "McKenzie County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "055", :name => "McLean County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "057", :name => "Mercer County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "059", :name => "Morton County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "061", :name => "Mountrail County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "063", :name => "Nelson County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "065", :name => "Oliver County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "067", :name => "Pembina County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "069", :name => "Pierce County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "071", :name => "Ramsey County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "073", :name => "Ransom County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "075", :name => "Renville County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "077", :name => "Richland County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "079", :name => "Rolette County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "081", :name => "Sargent County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "083", :name => "Sheridan County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "085", :name => "Sioux County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "087", :name => "Slope County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "089", :name => "Stark County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "091", :name => "Steele County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "093", :name => "Stutsman County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "095", :name => "Towner County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "097", :name => "Traill County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "099", :name => "Walsh County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "101", :name => "Ward County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "103", :name => "Wells County"}).save
#County.new({:state_fips_code => "38", :county_fips_code => "105", :name => "Williams County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "001", :name => "Adams County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "003", :name => "Antelope County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "005", :name => "Arthur County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "007", :name => "Banner County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "009", :name => "Blaine County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "011", :name => "Boone County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "013", :name => "Box Butte County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "015", :name => "Boyd County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "017", :name => "Brown County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "019", :name => "Buffalo County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "021", :name => "Burt County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "023", :name => "Butler County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "025", :name => "Cass County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "027", :name => "Cedar County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "029", :name => "Chase County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "031", :name => "Cherry County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "033", :name => "Cheyenne County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "035", :name => "Clay County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "037", :name => "Colfax County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "039", :name => "Cuming County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "041", :name => "Custer County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "043", :name => "Dakota County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "045", :name => "Dawes County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "047", :name => "Dawson County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "049", :name => "Deuel County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "051", :name => "Dixon County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "053", :name => "Dodge County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "055", :name => "Douglas County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "057", :name => "Dundy County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "059", :name => "Fillmore County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "061", :name => "Franklin County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "063", :name => "Frontier County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "065", :name => "Furnas County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "067", :name => "Gage County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "069", :name => "Garden County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "071", :name => "Garfield County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "073", :name => "Gosper County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "075", :name => "Grant County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "077", :name => "Greeley County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "079", :name => "Hall County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "081", :name => "Hamilton County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "083", :name => "Harlan County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "085", :name => "Hayes County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "087", :name => "Hitchcock County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "089", :name => "Holt County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "091", :name => "Hooker County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "093", :name => "Howard County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "095", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "097", :name => "Johnson County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "099", :name => "Kearney County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "101", :name => "Keith County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "103", :name => "Keya Paha County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "105", :name => "Kimball County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "107", :name => "Knox County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "109", :name => "Lancaster County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "111", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "113", :name => "Logan County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "115", :name => "Loup County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "117", :name => "McPherson County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "119", :name => "Madison County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "121", :name => "Merrick County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "123", :name => "Morrill County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "125", :name => "Nance County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "127", :name => "Nemaha County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "129", :name => "Nuckolls County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "131", :name => "Otoe County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "133", :name => "Pawnee County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "135", :name => "Perkins County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "137", :name => "Phelps County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "139", :name => "Pierce County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "141", :name => "Platte County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "143", :name => "Polk County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "145", :name => "Red Willow County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "147", :name => "Richardson County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "149", :name => "Rock County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "151", :name => "Saline County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "153", :name => "Sarpy County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "155", :name => "Saunders County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "157", :name => "Scotts Bluff County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "159", :name => "Seward County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "161", :name => "Sheridan County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "163", :name => "Sherman County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "165", :name => "Sioux County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "167", :name => "Stanton County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "169", :name => "Thayer County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "171", :name => "Thomas County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "173", :name => "Thurston County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "175", :name => "Valley County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "177", :name => "Washington County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "179", :name => "Wayne County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "181", :name => "Webster County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "183", :name => "Wheeler County"}).save
#County.new({:state_fips_code => "31", :county_fips_code => "185", :name => "York County"}).save
#County.new({:state_fips_code => "33", :county_fips_code => "001", :name => "Belknap County"}).save
#County.new({:state_fips_code => "33", :county_fips_code => "003", :name => "Carroll County"}).save
#County.new({:state_fips_code => "33", :county_fips_code => "005", :name => "Cheshire County"}).save
#County.new({:state_fips_code => "33", :county_fips_code => "007", :name => "Coos County"}).save
#County.new({:state_fips_code => "33", :county_fips_code => "009", :name => "Grafton County"}).save
#County.new({:state_fips_code => "33", :county_fips_code => "011", :name => "Hillsborough County"}).save
#County.new({:state_fips_code => "33", :county_fips_code => "013", :name => "Merrimack County"}).save
#County.new({:state_fips_code => "33", :county_fips_code => "015", :name => "Rockingham County"}).save
#County.new({:state_fips_code => "33", :county_fips_code => "017", :name => "Strafford County"}).save
#County.new({:state_fips_code => "33", :county_fips_code => "019", :name => "Sullivan County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "001", :name => "Atlantic County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "003", :name => "Bergen County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "005", :name => "Burlington County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "007", :name => "Camden County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "009", :name => "Cape May County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "011", :name => "Cumberland County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "013", :name => "Essex County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "015", :name => "Gloucester County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "017", :name => "Hudson County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "019", :name => "Hunterdon County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "021", :name => "Mercer County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "023", :name => "Middlesex County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "025", :name => "Monmouth County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "027", :name => "Morris County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "029", :name => "Ocean County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "031", :name => "Passaic County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "033", :name => "Salem County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "035", :name => "Somerset County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "037", :name => "Sussex County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "039", :name => "Union County"}).save
#County.new({:state_fips_code => "34", :county_fips_code => "041", :name => "Warren County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "001", :name => "Bernalillo County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "003", :name => "Catron County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "005", :name => "Chaves County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "006", :name => "Cibola County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "007", :name => "Colfax County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "009", :name => "Curry County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "011", :name => "DeBaca County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "013", :name => "Dona Ana County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "015", :name => "Eddy County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "017", :name => "Grant County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "019", :name => "Guadalupe County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "021", :name => "Harding County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "023", :name => "Hidalgo County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "025", :name => "Lea County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "027", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "028", :name => "Los Alamos County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "029", :name => "Luna County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "031", :name => "McKinley County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "033", :name => "Mora County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "035", :name => "Otero County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "037", :name => "Quay County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "039", :name => "Rio Arriba County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "041", :name => "Roosevelt County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "043", :name => "Sandoval County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "045", :name => "San Juan County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "047", :name => "San Miguel County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "049", :name => "Santa Fe County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "051", :name => "Sierra County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "053", :name => "Socorro County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "055", :name => "Taos County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "057", :name => "Torrance County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "059", :name => "Union County"}).save
#County.new({:state_fips_code => "35", :county_fips_code => "061", :name => "Valencia County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "001", :name => "Churchill County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "003", :name => "Clark County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "005", :name => "Douglas County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "007", :name => "Elko County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "009", :name => "Esmeralda County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "011", :name => "Eureka County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "013", :name => "Humboldt County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "015", :name => "Lander County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "017", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "019", :name => "Lyon County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "021", :name => "Mineral County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "023", :name => "Nye County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "027", :name => "Pershing County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "029", :name => "Storey County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "031", :name => "Washoe County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "033", :name => "White Pine County"}).save
#County.new({:state_fips_code => "32", :county_fips_code => "510", :name => "Carson City"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "001", :name => "Albany County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "003", :name => "Allegany County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "005", :name => "Bronx County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "007", :name => "Broome County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "009", :name => "Cattaraugus County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "011", :name => "Cayuga County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "013", :name => "Chautauqua County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "015", :name => "Chemung County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "017", :name => "Chenango County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "019", :name => "Clinton County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "021", :name => "Columbia County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "023", :name => "Cortland County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "025", :name => "Delaware County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "027", :name => "Dutchess County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "029", :name => "Erie County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "031", :name => "Essex County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "033", :name => "Franklin County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "035", :name => "Fulton County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "037", :name => "Genesee County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "039", :name => "Greene County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "041", :name => "Hamilton County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "043", :name => "Herkimer County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "045", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "047", :name => "Kings County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "049", :name => "Lewis County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "051", :name => "Livingston County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "053", :name => "Madison County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "055", :name => "Monroe County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "057", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "059", :name => "Nassau County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "061", :name => "New York County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "063", :name => "Niagara County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "065", :name => "Oneida County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "067", :name => "Onondaga County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "069", :name => "Ontario County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "071", :name => "Orange County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "073", :name => "Orleans County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "075", :name => "Oswego County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "077", :name => "Otsego County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "079", :name => "Putnam County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "081", :name => "Queens County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "083", :name => "Rensselaer County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "085", :name => "Richmond County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "087", :name => "Rockland County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "089", :name => "St. Lawrence County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "091", :name => "Saratoga County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "093", :name => "Schenectady County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "095", :name => "Schoharie County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "097", :name => "Schuyler County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "099", :name => "Seneca County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "101", :name => "Steuben County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "103", :name => "Suffolk County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "105", :name => "Sullivan County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "107", :name => "Tioga County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "109", :name => "Tompkins County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "111", :name => "Ulster County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "113", :name => "Warren County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "115", :name => "Washington County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "117", :name => "Wayne County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "119", :name => "Westchester County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "121", :name => "Wyoming County"}).save
#County.new({:state_fips_code => "36", :county_fips_code => "123", :name => "Yates County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "001", :name => "Adams County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "003", :name => "Allen County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "005", :name => "Ashland County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "007", :name => "Ashtabula County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "009", :name => "Athens County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "011", :name => "Auglaize County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "013", :name => "Belmont County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "015", :name => "Brown County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "017", :name => "Butler County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "019", :name => "Carroll County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "021", :name => "Champaign County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "023", :name => "Clark County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "025", :name => "Clermont County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "027", :name => "Clinton County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "029", :name => "Columbiana County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "031", :name => "Coshocton County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "033", :name => "Crawford County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "035", :name => "Cuyahoga County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "037", :name => "Darke County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "039", :name => "Defiance County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "041", :name => "Delaware County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "043", :name => "Erie County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "045", :name => "Fairfield County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "047", :name => "Fayette County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "049", :name => "Franklin County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "051", :name => "Fulton County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "053", :name => "Gallia County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "055", :name => "Geauga County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "057", :name => "Greene County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "059", :name => "Guernsey County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "061", :name => "Hamilton County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "063", :name => "Hancock County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "065", :name => "Hardin County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "067", :name => "Harrison County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "069", :name => "Henry County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "071", :name => "Highland County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "073", :name => "Hocking County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "075", :name => "Holmes County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "077", :name => "Huron County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "079", :name => "Jackson County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "081", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "083", :name => "Knox County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "085", :name => "Lake County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "087", :name => "Lawrence County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "089", :name => "Licking County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "091", :name => "Logan County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "093", :name => "Lorain County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "095", :name => "Lucas County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "097", :name => "Madison County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "099", :name => "Mahoning County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "101", :name => "Marion County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "103", :name => "Medina County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "105", :name => "Meigs County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "107", :name => "Mercer County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "109", :name => "Miami County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "111", :name => "Monroe County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "113", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "115", :name => "Morgan County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "117", :name => "Morrow County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "119", :name => "Muskingum County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "121", :name => "Noble County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "123", :name => "Ottawa County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "125", :name => "Paulding County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "127", :name => "Perry County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "129", :name => "Pickaway County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "131", :name => "Pike County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "133", :name => "Portage County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "135", :name => "Preble County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "137", :name => "Putnam County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "139", :name => "Richland County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "141", :name => "Ross County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "143", :name => "Sandusky County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "145", :name => "Scioto County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "147", :name => "Seneca County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "149", :name => "Shelby County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "151", :name => "Stark County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "153", :name => "Summit County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "155", :name => "Trumbull County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "157", :name => "Tuscarawas County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "159", :name => "Union County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "161", :name => "Van Wert County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "163", :name => "Vinton County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "165", :name => "Warren County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "167", :name => "Washington County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "169", :name => "Wayne County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "171", :name => "Williams County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "173", :name => "Wood County"}).save
#County.new({:state_fips_code => "39", :county_fips_code => "175", :name => "Wyandot County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "001", :name => "Adair County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "003", :name => "Alfalfa County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "005", :name => "Atoka County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "007", :name => "Beaver County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "009", :name => "Beckham County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "011", :name => "Blaine County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "013", :name => "Bryan County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "015", :name => "Caddo County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "017", :name => "Canadian County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "019", :name => "Carter County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "021", :name => "Cherokee County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "023", :name => "Choctaw County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "025", :name => "Cimarron County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "027", :name => "Cleveland County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "029", :name => "Coal County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "031", :name => "Comanche County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "033", :name => "Cotton County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "035", :name => "Craig County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "037", :name => "Creek County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "039", :name => "Custer County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "041", :name => "Delaware County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "043", :name => "Dewey County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "045", :name => "Ellis County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "047", :name => "Garfield County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "049", :name => "Garvin County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "051", :name => "Grady County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "053", :name => "Grant County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "055", :name => "Greer County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "057", :name => "Harmon County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "059", :name => "Harper County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "061", :name => "Haskell County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "063", :name => "Hughes County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "065", :name => "Jackson County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "067", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "069", :name => "Johnston County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "071", :name => "Kay County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "073", :name => "Kingfisher County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "075", :name => "Kiowa County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "077", :name => "Latimer County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "079", :name => "Le Flore County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "081", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "083", :name => "Logan County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "085", :name => "Love County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "087", :name => "McClain County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "089", :name => "McCurtain County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "091", :name => "McIntosh County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "093", :name => "Major County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "095", :name => "Marshall County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "097", :name => "Mayes County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "099", :name => "Murray County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "101", :name => "Muskogee County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "103", :name => "Noble County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "105", :name => "Nowata County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "107", :name => "Okfuskee County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "109", :name => "Oklahoma County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "111", :name => "Okmulgee County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "113", :name => "Osage County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "115", :name => "Ottawa County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "117", :name => "Pawnee County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "119", :name => "Payne County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "121", :name => "Pittsburg County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "123", :name => "Pontotoc County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "125", :name => "Pottawatomie County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "127", :name => "Pushmataha County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "129", :name => "Roger Mills County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "131", :name => "Rogers County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "133", :name => "Seminole County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "135", :name => "Sequoyah County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "137", :name => "Stephens County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "139", :name => "Texas County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "141", :name => "Tillman County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "143", :name => "Tulsa County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "145", :name => "Wagoner County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "147", :name => "Washington County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "149", :name => "Washita County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "151", :name => "Woods County"}).save
#County.new({:state_fips_code => "40", :county_fips_code => "153", :name => "Woodward County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "001", :name => "Baker County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "003", :name => "Benton County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "005", :name => "Clackamas County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "007", :name => "Clatsop County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "009", :name => "Columbia County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "011", :name => "Coos County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "013", :name => "Crook County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "015", :name => "Curry County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "017", :name => "Deschutes County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "019", :name => "Douglas County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "021", :name => "Gilliam County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "023", :name => "Grant County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "025", :name => "Harney County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "027", :name => "Hood River County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "029", :name => "Jackson County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "031", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "033", :name => "Josephine County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "035", :name => "Klamath County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "037", :name => "Lake County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "039", :name => "Lane County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "041", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "043", :name => "Linn County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "045", :name => "Malheur County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "047", :name => "Marion County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "049", :name => "Morrow County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "051", :name => "Multnomah County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "053", :name => "Polk County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "055", :name => "Sherman County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "057", :name => "Tillamook County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "059", :name => "Umatilla County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "061", :name => "Union County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "063", :name => "Wallowa County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "065", :name => "Wasco County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "067", :name => "Washington County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "069", :name => "Wheeler County"}).save
#County.new({:state_fips_code => "41", :county_fips_code => "071", :name => "Yamhill County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "001", :name => "Adams County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "003", :name => "Allegheny County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "005", :name => "Armstrong County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "007", :name => "Beaver County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "009", :name => "Bedford County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "011", :name => "Berks County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "013", :name => "Blair County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "015", :name => "Bradford County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "017", :name => "Bucks County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "019", :name => "Butler County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "021", :name => "Cambria County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "023", :name => "Cameron County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "025", :name => "Carbon County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "027", :name => "Centre County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "029", :name => "Chester County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "031", :name => "Clarion County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "033", :name => "Clearfield County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "035", :name => "Clinton County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "037", :name => "Columbia County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "039", :name => "Crawford County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "041", :name => "Cumberland County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "043", :name => "Dauphin County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "045", :name => "Delaware County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "047", :name => "Elk County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "049", :name => "Erie County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "051", :name => "Fayette County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "053", :name => "Forest County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "055", :name => "Franklin County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "057", :name => "Fulton County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "059", :name => "Greene County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "061", :name => "Huntingdon County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "063", :name => "Indiana County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "065", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "067", :name => "Juniata County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "069", :name => "Lackawanna County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "071", :name => "Lancaster County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "073", :name => "Lawrence County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "075", :name => "Lebanon County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "077", :name => "Lehigh County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "079", :name => "Luzerne County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "081", :name => "Lycoming County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "083", :name => "Mc Kean County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "085", :name => "Mercer County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "087", :name => "Mifflin County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "089", :name => "Monroe County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "091", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "093", :name => "Montour County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "095", :name => "Northampton County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "097", :name => "Northumberland County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "099", :name => "Perry County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "101", :name => "Philadelphia County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "103", :name => "Pike County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "105", :name => "Potter County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "107", :name => "Schuylkill County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "109", :name => "Snyder County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "111", :name => "Somerset County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "113", :name => "Sullivan County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "115", :name => "Susquehanna County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "117", :name => "Tioga County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "119", :name => "Union County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "121", :name => "Venango County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "123", :name => "Warren County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "125", :name => "Washington County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "127", :name => "Wayne County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "129", :name => "Westmoreland County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "131", :name => "Wyoming County"}).save
#County.new({:state_fips_code => "42", :county_fips_code => "133", :name => "York County"}).save
#County.new({:state_fips_code => "44", :county_fips_code => "001", :name => "Bristol County"}).save
#County.new({:state_fips_code => "44", :county_fips_code => "003", :name => "Kent County"}).save
#County.new({:state_fips_code => "44", :county_fips_code => "005", :name => "Newport County"}).save
#County.new({:state_fips_code => "44", :county_fips_code => "007", :name => "Providence County"}).save
#County.new({:state_fips_code => "44", :county_fips_code => "009", :name => "Washington County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "001", :name => "Abbeville County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "003", :name => "Aiken County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "005", :name => "Allendale County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "007", :name => "Anderson County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "009", :name => "Bamberg County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "011", :name => "Barnwell County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "013", :name => "Beaufort County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "015", :name => "Berkeley County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "017", :name => "Calhoun County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "019", :name => "Charleston County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "021", :name => "Cherokee County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "023", :name => "Chester County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "025", :name => "Chesterfield County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "027", :name => "Clarendon County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "029", :name => "Colleton County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "031", :name => "Darlington County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "033", :name => "Dillon County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "035", :name => "Dorchester County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "037", :name => "Edgefield County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "039", :name => "Fairfield County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "041", :name => "Florence County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "043", :name => "Georgetown County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "045", :name => "Greenville County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "047", :name => "Greenwood County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "049", :name => "Hampton County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "051", :name => "Horry County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "053", :name => "Jasper County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "055", :name => "Kershaw County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "057", :name => "Lancaster County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "059", :name => "Laurens County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "061", :name => "Lee County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "063", :name => "Lexington County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "065", :name => "McCormick County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "067", :name => "Marion County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "069", :name => "Marlboro County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "071", :name => "Newberry County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "073", :name => "Oconee County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "075", :name => "Orangeburg County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "077", :name => "Pickens County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "079", :name => "Richland County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "081", :name => "Saluda County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "083", :name => "Spartanburg County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "085", :name => "Sumter County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "087", :name => "Union County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "089", :name => "Williamsburg County"}).save
#County.new({:state_fips_code => "45", :county_fips_code => "091", :name => "York County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "003", :name => "Aurora County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "005", :name => "Beadle County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "007", :name => "Bennett County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "009", :name => "Bon Homme County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "011", :name => "Brookings County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "013", :name => "Brown County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "015", :name => "Brule County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "017", :name => "Buffalo County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "019", :name => "Butte County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "021", :name => "Campbell County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "023", :name => "Charles Mix County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "025", :name => "Clark County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "027", :name => "Clay County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "029", :name => "Codington County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "031", :name => "Corson County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "033", :name => "Custer County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "035", :name => "Davison County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "037", :name => "Day County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "039", :name => "Deuel County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "041", :name => "Dewey County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "043", :name => "Douglas County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "045", :name => "Edmunds County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "047", :name => "Fall River County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "049", :name => "Faulk County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "051", :name => "Grant County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "053", :name => "Gregory County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "055", :name => "Haakon County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "057", :name => "Hamlin County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "059", :name => "Hand County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "061", :name => "Hanson County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "063", :name => "Harding County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "065", :name => "Hughes County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "067", :name => "Hutchinson County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "069", :name => "Hyde County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "071", :name => "Jackson County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "073", :name => "Jerauld County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "075", :name => "Jones County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "077", :name => "Kingsbury County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "079", :name => "Lake County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "081", :name => "Lawrence County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "083", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "085", :name => "Lyman County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "087", :name => "McCook County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "089", :name => "McPherson County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "091", :name => "Marshall County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "093", :name => "Meade County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "095", :name => "Mellette County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "097", :name => "Miner County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "099", :name => "Minnehaha County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "101", :name => "Moody County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "103", :name => "Pennington County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "105", :name => "Perkins County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "107", :name => "Potter County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "109", :name => "Roberts County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "111", :name => "Sanborn County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "113", :name => "Shannon County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "115", :name => "Spink County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "117", :name => "Stanley County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "119", :name => "Sully County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "121", :name => "Todd County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "123", :name => "Tripp County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "125", :name => "Turner County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "127", :name => "Union County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "129", :name => "Walworth County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "135", :name => "Yankton County"}).save
#County.new({:state_fips_code => "46", :county_fips_code => "137", :name => "Ziebach County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "001", :name => "Anderson County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "003", :name => "Bedford County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "005", :name => "Benton County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "007", :name => "Bledsoe County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "009", :name => "Blount County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "011", :name => "Bradley County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "013", :name => "Campbell County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "015", :name => "Cannon County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "017", :name => "Carroll County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "019", :name => "Carter County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "021", :name => "Cheatham County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "023", :name => "Chester County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "025", :name => "Claiborne County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "027", :name => "Clay County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "029", :name => "Cocke County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "031", :name => "Coffee County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "033", :name => "Crockett County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "035", :name => "Cumberland County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "037", :name => "Davidson County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "039", :name => "Decatur County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "041", :name => "DeKalb County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "043", :name => "Dickson County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "045", :name => "Dyer County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "047", :name => "Fayette County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "049", :name => "Fentress County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "051", :name => "Franklin County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "053", :name => "Gibson County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "055", :name => "Giles County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "057", :name => "Grainger County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "059", :name => "Greene County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "061", :name => "Grundy County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "063", :name => "Hamblen County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "065", :name => "Hamilton County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "067", :name => "Hancock County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "069", :name => "Hardeman County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "071", :name => "Hardin County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "073", :name => "Hawkins County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "075", :name => "Haywood County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "077", :name => "Henderson County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "079", :name => "Henry County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "081", :name => "Hickman County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "083", :name => "Houston County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "085", :name => "Humphreys County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "087", :name => "Jackson County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "089", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "091", :name => "Johnson County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "093", :name => "Knox County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "095", :name => "Lake County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "097", :name => "Lauderdale County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "099", :name => "Lawrence County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "101", :name => "Lewis County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "103", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "105", :name => "Loudon County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "107", :name => "McMinn County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "109", :name => "McNairy County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "111", :name => "Macon County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "113", :name => "Madison County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "115", :name => "Marion County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "117", :name => "Marshall County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "119", :name => "Maury County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "121", :name => "Meigs County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "123", :name => "Monroe County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "125", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "127", :name => "Moore County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "129", :name => "Morgan County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "131", :name => "Obion County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "133", :name => "Overton County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "135", :name => "Perry County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "137", :name => "Pickett County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "139", :name => "Polk County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "141", :name => "Putnam County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "143", :name => "Rhea County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "145", :name => "Roane County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "147", :name => "Robertson County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "149", :name => "Rutherford County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "151", :name => "Scott County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "153", :name => "Sequatchie County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "155", :name => "Sevier County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "157", :name => "Shelby County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "159", :name => "Smith County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "161", :name => "Stewart County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "163", :name => "Sullivan County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "165", :name => "Sumner County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "167", :name => "Tipton County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "169", :name => "Trousdale County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "171", :name => "Unicoi County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "173", :name => "Union County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "175", :name => "Van Buren County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "177", :name => "Warren County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "179", :name => "Washington County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "181", :name => "Wayne County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "183", :name => "Weakley County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "185", :name => "White County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "187", :name => "Williamson County"}).save
#County.new({:state_fips_code => "47", :county_fips_code => "189", :name => "Wilson County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "001", :name => "Anderson County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "003", :name => "Andrews County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "005", :name => "Angelina County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "007", :name => "Aransas County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "009", :name => "Archer County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "011", :name => "Armstrong County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "013", :name => "Atascosa County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "015", :name => "Austin County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "017", :name => "Bailey County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "019", :name => "Bandera County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "021", :name => "Bastrop County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "023", :name => "Baylor County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "025", :name => "Bee County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "027", :name => "Bell County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "029", :name => "Bexar County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "031", :name => "Blanco County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "033", :name => "Borden County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "035", :name => "Bosque County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "037", :name => "Bowie County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "039", :name => "Brazoria County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "041", :name => "Brazos County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "043", :name => "Brewster County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "045", :name => "Briscoe County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "047", :name => "Brooks County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "049", :name => "Brown County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "051", :name => "Burleson County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "053", :name => "Burnet County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "055", :name => "Caldwell County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "057", :name => "Calhoun County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "059", :name => "Callahan County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "061", :name => "Cameron County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "063", :name => "Camp County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "065", :name => "Carson County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "067", :name => "Cass County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "069", :name => "Castro County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "071", :name => "Chambers County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "073", :name => "Cherokee County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "075", :name => "Childress County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "077", :name => "Clay County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "079", :name => "Cochran County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "081", :name => "Coke County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "083", :name => "Coleman County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "085", :name => "Collin County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "087", :name => "Collingsworth County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "089", :name => "Colorado County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "091", :name => "Comal County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "093", :name => "Comanche County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "095", :name => "Concho County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "097", :name => "Cooke County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "099", :name => "Coryell County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "101", :name => "Cottle County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "103", :name => "Crane County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "105", :name => "Crockett County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "107", :name => "Crosby County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "109", :name => "Culberson County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "111", :name => "Dallam County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "113", :name => "Dallas County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "115", :name => "Dawson County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "117", :name => "Deaf Smith County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "119", :name => "Delta County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "121", :name => "Denton County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "123", :name => "DeWitt County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "125", :name => "Dickens County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "127", :name => "Dimmit County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "129", :name => "Donley County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "131", :name => "Duval County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "133", :name => "Eastland County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "135", :name => "Ector County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "137", :name => "Edwards County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "139", :name => "Ellis County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "141", :name => "El Paso County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "143", :name => "Erath County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "145", :name => "Falls County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "147", :name => "Fannin County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "149", :name => "Fayette County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "151", :name => "Fisher County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "153", :name => "Floyd County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "155", :name => "Foard County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "157", :name => "Fort Bend County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "159", :name => "Franklin County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "161", :name => "Freestone County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "163", :name => "Frio County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "165", :name => "Gaines County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "167", :name => "Galveston County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "169", :name => "Garza County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "171", :name => "Gillespie County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "173", :name => "Glasscock County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "175", :name => "Goliad County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "177", :name => "Gonzales County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "179", :name => "Gray County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "181", :name => "Grayson County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "183", :name => "Gregg County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "185", :name => "Grimes County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "187", :name => "Guadalupe County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "189", :name => "Hale County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "191", :name => "Hall County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "193", :name => "Hamilton County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "195", :name => "Hansford County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "197", :name => "Hardeman County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "199", :name => "Hardin County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "201", :name => "Harris County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "203", :name => "Harrison County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "205", :name => "Hartley County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "207", :name => "Haskell County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "209", :name => "Hays County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "211", :name => "Hemphill County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "213", :name => "Henderson County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "215", :name => "Hidalgo County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "217", :name => "Hill County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "219", :name => "Hockley County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "221", :name => "Hood County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "223", :name => "Hopkins County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "225", :name => "Houston County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "227", :name => "Howard County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "229", :name => "Hudspeth County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "231", :name => "Hunt County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "233", :name => "Hutchinson County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "235", :name => "Irion County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "237", :name => "Jack County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "239", :name => "Jackson County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "241", :name => "Jasper County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "243", :name => "Jeff Davis County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "245", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "247", :name => "Jim Hogg County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "249", :name => "Jim Wells County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "251", :name => "Johnson County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "253", :name => "Jones County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "255", :name => "Karnes County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "257", :name => "Kaufman County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "259", :name => "Kendall County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "261", :name => "Kenedy County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "263", :name => "Kent County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "265", :name => "Kerr County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "267", :name => "Kimble County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "269", :name => "King County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "271", :name => "Kinney County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "273", :name => "Kleberg County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "275", :name => "Knox County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "277", :name => "Lamar County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "279", :name => "Lamb County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "281", :name => "Lampasas County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "283", :name => "La Salle County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "285", :name => "Lavaca County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "287", :name => "Lee County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "289", :name => "Leon County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "291", :name => "Liberty County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "293", :name => "Limestone County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "295", :name => "Lipscomb County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "297", :name => "Live Oak County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "299", :name => "Llano County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "301", :name => "Loving County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "303", :name => "Lubbock County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "305", :name => "Lynn County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "307", :name => "McCulloch County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "309", :name => "McLennan County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "311", :name => "McMullen County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "313", :name => "Madison County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "315", :name => "Marion County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "317", :name => "Martin County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "319", :name => "Mason County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "321", :name => "Matagorda County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "323", :name => "Maverick County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "325", :name => "Medina County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "327", :name => "Menard County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "329", :name => "Midland County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "331", :name => "Milam County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "333", :name => "Mills County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "335", :name => "Mitchell County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "337", :name => "Montague County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "339", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "341", :name => "Moore County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "343", :name => "Morris County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "345", :name => "Motley County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "347", :name => "Nacogdoches County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "349", :name => "Navarro County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "351", :name => "Newton County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "353", :name => "Nolan County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "355", :name => "Nueces County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "357", :name => "Ochiltree County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "359", :name => "Oldham County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "361", :name => "Orange County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "363", :name => "Palo Pinto County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "365", :name => "Panola County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "367", :name => "Parker County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "369", :name => "Parmer County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "371", :name => "Pecos County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "373", :name => "Polk County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "375", :name => "Potter County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "377", :name => "Presidio County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "379", :name => "Rains County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "381", :name => "Randall County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "383", :name => "Reagan County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "385", :name => "Real County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "387", :name => "Red River County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "389", :name => "Reeves County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "391", :name => "Refugio County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "393", :name => "Roberts County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "395", :name => "Robertson County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "397", :name => "Rockwall County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "399", :name => "Runnels County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "401", :name => "Rusk County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "403", :name => "Sabine County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "405", :name => "San Augustine County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "407", :name => "San Jacinto County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "409", :name => "San Patricio County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "411", :name => "San Saba County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "413", :name => "Schleicher County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "415", :name => "Scurry County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "417", :name => "Shackelford County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "419", :name => "Shelby County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "421", :name => "Sherman County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "423", :name => "Smith County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "425", :name => "Somervell County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "427", :name => "Starr County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "429", :name => "Stephens County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "431", :name => "Sterling County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "433", :name => "Stonewall County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "435", :name => "Sutton County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "437", :name => "Swisher County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "439", :name => "Tarrant County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "441", :name => "Taylor County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "443", :name => "Terrell County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "445", :name => "Terry County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "447", :name => "Throckmorton County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "449", :name => "Titus County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "451", :name => "Tom Green County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "453", :name => "Travis County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "455", :name => "Trinity County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "457", :name => "Tyler County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "459", :name => "Upshur County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "461", :name => "Upton County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "463", :name => "Uvalde County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "465", :name => "Val Verde County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "467", :name => "Van Zandt County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "469", :name => "Victoria County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "471", :name => "Walker County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "473", :name => "Waller County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "475", :name => "Ward County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "477", :name => "Washington County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "479", :name => "Webb County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "481", :name => "Wharton County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "483", :name => "Wheeler County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "485", :name => "Wichita County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "487", :name => "Wilbarger County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "489", :name => "Willacy County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "491", :name => "Williamson County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "493", :name => "Wilson County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "495", :name => "Winkler County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "497", :name => "Wise County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "499", :name => "Wood County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "501", :name => "Yoakum County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "503", :name => "Young County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "505", :name => "Zapata County"}).save
#County.new({:state_fips_code => "48", :county_fips_code => "507", :name => "Zavala County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "001", :name => "Beaver County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "003", :name => "Box Elder County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "005", :name => "Cache County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "007", :name => "Carbon County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "009", :name => "Daggett County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "011", :name => "Davis County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "013", :name => "Duchesne County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "015", :name => "Emery County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "017", :name => "Garfield County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "019", :name => "Grand County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "021", :name => "Iron County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "023", :name => "Juab County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "025", :name => "Kane County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "027", :name => "Millard County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "029", :name => "Morgan County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "031", :name => "Piute County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "033", :name => "Rich County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "035", :name => "Salt Lake County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "037", :name => "San Juan County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "039", :name => "Sanpete County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "041", :name => "Sevier County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "043", :name => "Summit County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "045", :name => "Tooele County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "047", :name => "Uintah County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "049", :name => "Utah County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "051", :name => "Wasatch County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "053", :name => "Washington County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "055", :name => "Wayne County"}).save
#County.new({:state_fips_code => "49", :county_fips_code => "057", :name => "Weber County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "001", :name => "Accomack County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "003", :name => "Albemarle County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "005", :name => "Alleghany County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "007", :name => "Amelia County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "009", :name => "Amherst County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "011", :name => "Appomattox County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "013", :name => "Arlington County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "015", :name => "Augusta County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "017", :name => "Bath County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "019", :name => "Bedford County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "021", :name => "Bland County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "023", :name => "Botetourt County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "025", :name => "Brunswick County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "027", :name => "Buchanan County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "029", :name => "Buckingham County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "031", :name => "Campbell County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "033", :name => "Caroline County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "035", :name => "Carroll County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "036", :name => "Charles City County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "037", :name => "Charlotte County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "041", :name => "Chesterfield County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "043", :name => "Clarke County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "045", :name => "Craig County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "047", :name => "Culpeper County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "049", :name => "Cumberland County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "051", :name => "Dickenson County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "053", :name => "Dinwiddie County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "057", :name => "Essex County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "059", :name => "Fairfax County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "061", :name => "Fauquier County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "063", :name => "Floyd County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "065", :name => "Fluvanna County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "067", :name => "Franklin County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "069", :name => "Frederick County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "071", :name => "Giles County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "073", :name => "Gloucester County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "075", :name => "Goochland County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "077", :name => "Grayson County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "079", :name => "Greene County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "081", :name => "Greensville County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "083", :name => "Halifax County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "085", :name => "Hanover County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "087", :name => "Henrico County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "089", :name => "Henry County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "091", :name => "Highland County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "093", :name => "Isle of Wight County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "095", :name => "James City County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "097", :name => "King and Queen County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "099", :name => "King George County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "101", :name => "King William County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "103", :name => "Lancaster County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "105", :name => "Lee County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "107", :name => "Loudoun County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "109", :name => "Louisa County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "111", :name => "Lunenburg County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "113", :name => "Madison County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "115", :name => "Mathews County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "117", :name => "Mecklenburg County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "119", :name => "Middlesex County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "121", :name => "Montgomery County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "125", :name => "Nelson County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "127", :name => "New Kent County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "131", :name => "Northampton County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "133", :name => "Northumberland County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "135", :name => "Nottoway County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "137", :name => "Orange County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "139", :name => "Page County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "141", :name => "Patrick County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "143", :name => "Pittsylvania County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "145", :name => "Powhatan County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "147", :name => "Prince Edward County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "149", :name => "Prince George County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "153", :name => "Prince William County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "155", :name => "Pulaski County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "157", :name => "Rappahannock County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "159", :name => "Richmond County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "161", :name => "Roanoke County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "163", :name => "Rockbridge County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "165", :name => "Rockingham County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "167", :name => "Russell County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "169", :name => "Scott County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "171", :name => "Shenandoah County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "173", :name => "Smyth County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "175", :name => "Southampton County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "177", :name => "Spotsylvania County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "179", :name => "Stafford County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "181", :name => "Surry County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "183", :name => "Sussex County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "185", :name => "Tazewell County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "187", :name => "Warren County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "191", :name => "Washington County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "193", :name => "Westmoreland County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "195", :name => "Wise County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "197", :name => "Wythe County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "199", :name => "York County"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "510", :name => "Alexandria city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "515", :name => "Bedford city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "520", :name => "Bristol city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "530", :name => "Buena Vista city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "540", :name => "Charlottesville city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "550", :name => "Chesapeake city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "560", :name => "Clifton Forge city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "570", :name => "Colonial Heights city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "580", :name => "Covington city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "590", :name => "Danville city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "595", :name => "Emporia city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "600", :name => "Fairfax city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "610", :name => "Falls Church city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "620", :name => "Franklin city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "630", :name => "Fredericksburg city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "640", :name => "Galax city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "650", :name => "Hampton city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "660", :name => "Harrisonburg city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "670", :name => "Hopewell city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "678", :name => "Lexington city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "680", :name => "Lynchburg city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "683", :name => "Manassas city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "685", :name => "Manassas Park city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "690", :name => "Martinsville city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "700", :name => "Newport News city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "710", :name => "Norfolk city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "720", :name => "Norton city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "730", :name => "Petersburg city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "735", :name => "Poquoson city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "740", :name => "Portsmouth city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "750", :name => "Radford city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "760", :name => "Richmond city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "770", :name => "Roanoke city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "775", :name => "Salem city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "780", :name => "South Boston city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "790", :name => "Staunton city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "800", :name => "Suffolk city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "810", :name => "Virginia Beach city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "820", :name => "Waynesboro city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "830", :name => "Williamsburg city"}).save
#County.new({:state_fips_code => "51", :county_fips_code => "840", :name => "Winchester city"}).save
#County.new({:state_fips_code => "50", :county_fips_code => "001", :name => "Addison County"}).save
#County.new({:state_fips_code => "50", :county_fips_code => "003", :name => "Bennington County"}).save
#County.new({:state_fips_code => "50", :county_fips_code => "005", :name => "Caledonia County"}).save
#County.new({:state_fips_code => "50", :county_fips_code => "007", :name => "Chittenden County"}).save
#County.new({:state_fips_code => "50", :county_fips_code => "009", :name => "Essex County"}).save
#County.new({:state_fips_code => "50", :county_fips_code => "011", :name => "Franklin County"}).save
#County.new({:state_fips_code => "50", :county_fips_code => "013", :name => "Grand Isle County"}).save
#County.new({:state_fips_code => "50", :county_fips_code => "015", :name => "Lamoille County"}).save
#County.new({:state_fips_code => "50", :county_fips_code => "017", :name => "Orange County"}).save
#County.new({:state_fips_code => "50", :county_fips_code => "019", :name => "Orleans County"}).save
#County.new({:state_fips_code => "50", :county_fips_code => "021", :name => "Rutland County"}).save
#County.new({:state_fips_code => "50", :county_fips_code => "023", :name => "Washington County"}).save
#County.new({:state_fips_code => "50", :county_fips_code => "025", :name => "Windham County"}).save
#County.new({:state_fips_code => "50", :county_fips_code => "027", :name => "Windsor County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "001", :name => "Adams County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "003", :name => "Asotin County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "005", :name => "Benton County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "007", :name => "Chelan County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "009", :name => "Clallam County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "011", :name => "Clark County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "013", :name => "Columbia County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "015", :name => "Cowlitz County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "017", :name => "Douglas County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "019", :name => "Ferry County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "021", :name => "Franklin County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "023", :name => "Garfield County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "025", :name => "Grant County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "027", :name => "Grays Harbor County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "029", :name => "Island County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "031", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "033", :name => "King County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "035", :name => "Kitsap County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "037", :name => "Kittitas County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "039", :name => "Klickitat County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "041", :name => "Lewis County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "043", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "045", :name => "Mason County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "047", :name => "Okanogan County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "049", :name => "Pacific County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "051", :name => "Pend Oreille County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "053", :name => "Pierce County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "055", :name => "San Juan County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "057", :name => "Skagit County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "059", :name => "Skamania County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "061", :name => "Snohomish County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "063", :name => "Spokane County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "065", :name => "Stevens County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "067", :name => "Thurston County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "069", :name => "Wahkiakum County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "071", :name => "Walla Walla County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "073", :name => "Whatcom County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "075", :name => "Whitman County"}).save
#County.new({:state_fips_code => "53", :county_fips_code => "077", :name => "Yakima County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "001", :name => "Adams County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "003", :name => "Ashland County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "005", :name => "Barron County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "007", :name => "Bayfield County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "009", :name => "Brown County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "011", :name => "Buffalo County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "013", :name => "Burnett County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "015", :name => "Calumet County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "017", :name => "Chippewa County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "019", :name => "Clark County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "021", :name => "Columbia County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "023", :name => "Crawford County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "025", :name => "Dane County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "027", :name => "Dodge County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "029", :name => "Door County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "031", :name => "Douglas County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "033", :name => "Dunn County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "035", :name => "Eau Claire County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "037", :name => "Florence County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "039", :name => "Fond du Lac County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "041", :name => "Forest County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "043", :name => "Grant County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "045", :name => "Green County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "047", :name => "Green Lake County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "049", :name => "Iowa County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "051", :name => "Iron County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "053", :name => "Jackson County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "055", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "057", :name => "Juneau County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "059", :name => "Kenosha County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "061", :name => "Kewaunee County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "063", :name => "La Crosse County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "065", :name => "Lafayette County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "067", :name => "Langlade County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "069", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "071", :name => "Manitowoc County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "073", :name => "Marathon County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "075", :name => "Marinette County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "077", :name => "Marquette County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "078", :name => "Menominee County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "079", :name => "Milwaukee County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "081", :name => "Monroe County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "083", :name => "Oconto County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "085", :name => "Oneida County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "087", :name => "Outagamie County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "089", :name => "Ozaukee County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "091", :name => "Pepin County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "093", :name => "Pierce County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "095", :name => "Polk County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "097", :name => "Portage County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "099", :name => "Price County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "101", :name => "Racine County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "103", :name => "Richland County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "105", :name => "Rock County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "107", :name => "Rusk County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "109", :name => "St. Croix County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "111", :name => "Sauk County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "113", :name => "Sawyer County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "115", :name => "Shawano County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "117", :name => "Sheboygan County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "119", :name => "Taylor County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "121", :name => "Trempealeau County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "123", :name => "Vernon County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "125", :name => "Vilas County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "127", :name => "Walworth County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "129", :name => "Washburn County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "131", :name => "Washington County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "133", :name => "Waukesha County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "135", :name => "Waupaca County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "137", :name => "Waushara County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "139", :name => "Winnebago County"}).save
#County.new({:state_fips_code => "55", :county_fips_code => "141", :name => "Wood County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "001", :name => "Barbour County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "003", :name => "Berkeley County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "005", :name => "Boone County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "007", :name => "Braxton County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "009", :name => "Brooke County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "011", :name => "Cabell County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "013", :name => "Calhoun County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "015", :name => "Clay County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "017", :name => "Doddridge County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "019", :name => "Fayette County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "021", :name => "Gilmer County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "023", :name => "Grant County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "025", :name => "Greenbrier County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "027", :name => "Hampshire County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "029", :name => "Hancock County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "031", :name => "Hardy County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "033", :name => "Harrison County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "035", :name => "Jackson County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "037", :name => "Jefferson County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "039", :name => "Kanawha County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "041", :name => "Lewis County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "043", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "045", :name => "Logan County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "047", :name => "McDowell County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "049", :name => "Marion County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "051", :name => "Marshall County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "053", :name => "Mason County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "055", :name => "Mercer County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "057", :name => "Mineral County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "059", :name => "Mingo County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "061", :name => "Monongalia County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "063", :name => "Monroe County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "065", :name => "Morgan County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "067", :name => "Nicholas County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "069", :name => "Ohio County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "071", :name => "Pendleton County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "073", :name => "Pleasants County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "075", :name => "Pocahontas County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "077", :name => "Preston County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "079", :name => "Putnam County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "081", :name => "Raleigh County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "083", :name => "Randolph County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "085", :name => "Ritchie County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "087", :name => "Roane County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "089", :name => "Summers County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "091", :name => "Taylor County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "093", :name => "Tucker County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "095", :name => "Tyler County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "097", :name => "Upshur County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "099", :name => "Wayne County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "101", :name => "Webster County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "103", :name => "Wetzel County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "105", :name => "Wirt County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "107", :name => "Wood County"}).save
#County.new({:state_fips_code => "54", :county_fips_code => "109", :name => "Wyoming County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "001", :name => "Albany County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "003", :name => "Big Horn County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "005", :name => "Campbell County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "007", :name => "Carbon County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "009", :name => "Converse County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "011", :name => "Crook County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "013", :name => "Fremont County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "015", :name => "Goshen County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "017", :name => "Hot Springs County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "019", :name => "Johnson County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "021", :name => "Laramie County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "023", :name => "Lincoln County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "025", :name => "Natrona County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "027", :name => "Niobrara County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "029", :name => "Park County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "031", :name => "Platte County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "033", :name => "Sheridan County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "035", :name => "Sublette County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "037", :name => "Sweetwater County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "039", :name => "Teton County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "041", :name => "Uinta County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "043", :name => "Washakie County"}).save
#County.new({:state_fips_code => "56", :county_fips_code => "045", :name => "Weston County"}).save
#
#puts "Compacting database..."
#County.database.compact!

puts "Done!"
