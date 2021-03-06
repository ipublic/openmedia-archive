require 'rdf/couchdb'
require 'open_media/schema/data_design_doc'

module OpenMedia
  module Schema
    module SKOS
      class Collection < OpenMedia::Schema::Base
        
        default_source 'types'
        type ::RDF::SKOS.Collection  

        property :label, :predicate=>::RDF::SKOS.prefLabel, :type=>XSD.string
        property :definition, :predicate=>::RDF::SKOS.definition, :type=>XSD.string        
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

        def contains?(collection_or_concept)
          !members.detect{|m| m==collection_or_concept.uri}.nil?
        end

        def repository
          site_identifier = self.uri.path.split('/')[1]          
          db_name = "#{site_identifier}_#{self.identifier}"
          unless Spira.repository(db_name)
            db = COUCHDB_SERVER.database!("#{db_name}")
            OpenMedia::Schema::DataDesignDoc.refresh(db)
            Spira.add_repository! db_name, ::RDF::CouchDB::Repository.new(:database=>db)
          end
          db_name
        end

        def before_destroy
          self.concepts.each {|c| c.rdfs_class.destroy!; c.destroy!}
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
  

