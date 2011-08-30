## Initialize the Commons Collections
require 'rdf/couchdb'

ns = ::OmLinkedData::Namespace.new(@om_site.url)
::OmLinkedData::Collection.create!(:base_uri => ns.base_uri, 
                                    :label=> 'Core', 
                                    :authority => ns.authority, 
                                    :tags => ["intrinsic", "default", "base"], 
                                    :comment => "The Core collection includes OpenMedia built-in types.")

::OmLinkedData::Collection.create!(:base_uri => ns.base_uri, :label=> 'Addresses', 
  :authority => ns.authority, 
  :tags => ["residence", "house", "home", "headquarters", "place", "business", "location", "intersection", 
            "100 block", "site address", "po box", "url", "uri"], 
  :comment => 
  "The Addresses collection includes unique designations for physical locations and identifiers for non-physical resources such as a web page.  Examples include: home and business site addresses, road intersections and Web page URL's")

collections = [
  'Agriculture', 'Arts', 'Animal Control',
  'Business',
  'Citizens', 'Community Services', 'Council and Boards',
  'Demographics',
  'Economy', 'Elections', 'Education', 'Environment', 'Energy',
  'Finance',
  'Government',
  'Health', 'Housing', 'Human Services',
  'Insurance',
  'Justice',
  'Licenses and Permits', 'Labor Force',
  'Military', 'Motor Vehicles', 
  'Natural Resources', 'Neighborhoods',
  'Parks and Recreation', 'People', 'Performance Management', 'Physical Geography', 'Planning', 'Property', 'Public Safety', 'Public Works',
  'Science', 
  'Technology and Communication', 'Transportation',
  'Utilities',
  'Weather'
  ]

collections.sort.each { |col| ::OmLinkedData::Collection.create!(:label=> col, 
                                                                :base_uri => ns.base_uri,
                                                                :authority => ns.authority
                                                                )}


