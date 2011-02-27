require 'rdf/couchdb'

module OpenMedia
  module Schema
    module SKOS
      class Collection < OpenMedia::Schema::Base
        
        default_source 'types'
        type ::RDF::SKOS.Collection  

        property :label, :predicate=>::RDF::SKOS.prefLabel, :type=>XSD.string
        property :hidden, :predicate=>::RDF::OM_CORE.hidden, :type=>XSD.boolean
        has_many :members, :predicate=>::RDF::SKOS.member

        validate :label_set

        def sub_collections
          members.collect{|m| OpenMedia::Schema::SKOS::Collection.for(m)}
        end

        def concepts
          members.collect{|c| OpenMedia::Schema::SKOS::Concept.for(c)}
        end

        def label_set
          errors.add(:label, "Label cannot be blank") if self.label.blank?
        end

        def delete_member!(member_uri)
          self.members.reject! {|m| m == member_uri}
          self.save!
        end

        def identifier
          self.uri.path.split('/').last
        end

        def repository
          db_name = "#{OpenMedia::Site.instance.identifier}_#{self.identifier}"
          unless Spira.repository(db_name)
            db = COUCHDB_SERVER.database!("#{db_name}")
            Spira.add_repository! db_name, ::RDF::CouchDB::Repository.new(:database=>db)
          end
          db_name
        end

        
        def self.create_in_collection!(collection, data)
          c = nil
          begin
            identifier = data[:label].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')    
            if identifier.blank?
              c = self.new
            else
              c = self.for(collection.uri/identifier, data)
            end

            raise Exception.new("Collection #{identifier} already exists") if c.exists?

            c.save!
            collection.members << c.uri
            collection.save!
          rescue; end
          c
        end
      end
    end
  end
end
  

