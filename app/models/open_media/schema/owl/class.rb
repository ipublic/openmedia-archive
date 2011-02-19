OpenMedia::Schema::OWL::ObjectProperty   # this is here to make Rails autoloading and Spira play nice together

class OpenMedia::Schema::OWL::Class < OpenMedia::Schema::RDFS::Class
  type OWL.Class

  has_many :object_properties, :predicate=>OWL.ObjectProperty, :type=>:'OpenMedia::Schema::OWL::ObjectProperty'
  has_many :datatype_properties, :predicate=>OWL.DatatypeProperty, :type=>:'OpenMedia::Schema::OWL::DatatypeProperty'  

  def self.create_in_site!(site, data)
    identifier = data[:label].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')
    c = self.for("#{site.identifier}/classes/#{identifier}", data)
    raise Exception.new("Class #{identifier} already exists") if c.exists?    
    c.save!
    c    
  end
  
  # define a new Spira resource, subclassed from OpenMedia::Schema::Base
  def spira_resource
    cls_name = self.uri.path.split('/').collect{|p| p.classify}.join
    if !self.class.const_defined?(cls_name)
      cls = Class.new(OpenMedia::Schema::Base)
      cls.default_source(self.class.repository_name)
      cls.type(self.uri)
      [self.properties, self.object_properties, self.datatype_properties].each do |prop_list|
        prop_list.each do |p|
          if Spira.types[p.range]
            ptype = p.range
          else
            ptype = class_for_uri(p.range).spira_resource.name.to_sym
          end
          cls.property(p.identifier.to_sym, :predicate=>p.uri, :type=>ptype)
        end
      end
      self.class.const_set(cls_name, cls)
    end
    self.class.const_get(cls_name)
  end

end



