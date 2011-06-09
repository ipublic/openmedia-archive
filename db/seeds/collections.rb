## Initialize the Commons Collections
collections = [
  'Addresses', 'Agriculture', 'Arts', 'Animal Control',
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

collections.sort.each { |col| ::OmLinkedData::Collection.create!(:label=> col, :base_uri => @om_site.url)}

# "The Addresses collection includes unique designations for physical locations and identifiers for non-physical resources such as a web page.  Examples include: home and business site addresses, road intersections and Web page URL's"
