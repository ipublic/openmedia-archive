module OpenMedia
  module Inspect
    class SiteQuery

  @om_site_id = 'ipublic'

## TODO -- simplify into a get -- can we make unique site_id the key?
  @om_site = OpenMedia::Site.all.detect{|s| s.subdomain == @om_site_id}
  puts "Info for site: #{@om_site_id}"
  puts "  url: #{@om_site.url}"
  puts "  Internal server: #{@om_site.public_couchdb_server_uri}"
  puts "  Public server:   #{@om_site.public_couchdb_server_uri}"
  puts "  Muni: #{@om_site.municipality['name']}"
  puts "    Lat: #{@om_site.municipality['geometries'][0]['coordinates'][1]}"
  puts "    Lat: #{@om_site.municipality['geometries'][0]['coordinates'][0]}"
  puts "  url: #{@om_site.url}"
  puts "  url: #{@om_site.url}"

  # returns an Array of OpenMedia::Schema::SKOS::Collection
  @site_collections = @om_site.skos_collection.sub_collections

  @first_collection = OpenMedia::Schema::SKOS::Collection.for(@site_collections.first)
  puts "First Collection"
  puts "  Name: #{@first_collection.label}"
  puts "  id:   #{@first_collection.identifier}"
  puts "  uri: #{@first_collection.uri}"
  puts "  No. classes: #{@first_collection.members.size}"

  # hard coded for collection with classes
  @my_collection = OpenMedia::Schema::SKOS::Collection.for("http://data.civicopenmedia.org/ipubliccivicopenmedialocal/concepts/public_safety")
  puts "My Collection"
  puts "  Name: #{@my_collection.label}"
  puts "  id:   #{@my_collection.identifier}"
  puts "  uri: #{@my_collection.uri}"
  puts "  No. classes: #{@my_collection.members.size}"

  # returns an array of OpenMedia::Schema::SKOS::Concept
  @my_classes = @my_collection.concepts
  # @my_classes = @my_collection.concepts.collect {|c| c.rdfs_class}.select{|c| @om_site.skos_collection.uri.parent==c.uri.parent.parent}
  @my_class = @my_classes.first

  puts "My Class"
  puts "  uri: #{@my_class.uri}"
  puts "  rdfs class: #{@my_class.rdfs_class}"

  # Collection is an array of OpenMedia::Schema::SKOS::Concept
  # The OpenMedia::Schema::SKOS::Concept#uri returns RDF::URI.  
  # API should accept object
  @dfn = OpenMedia::Schema.get_class_definition(@my_class.uri.to_s)
  puts "Class Definition"
  puts "  Label: #{@dfn['label']}"
  puts "  Property List"
  @props = @dfn['properties']
  @props.each do |prop|
    puts "    Label, id: #{prop['label']}, #{prop['identifier']}"
  end
  
  @recs = OpenMedia::Schema.get_records(@my_class.uri.to_s)
  puts "First Record"
  @rec = @recs.first
  @props.each do |prop|
    puts "  #{prop['label']}: #{@rec[prop['identifier'].sub('#','')]}"
  end
end
end
end
