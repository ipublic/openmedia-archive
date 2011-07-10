class Schemas::VCard::VCard < CouchRest::Model::Base
  
  use_database TYPES_DATABASE     # change to different DB?

  property :address, [Schemas::VCard::Address]            # :alias => :adr
  property :email, [Schemas::VCard::Email]                # :alias => :email
  property :name, Schemas::VCard::Name                  # :alias => :n
  property :organization, Schemas::VCard::Organization    # :alias => :org
  property :telephone, [Schemas::VCard::Telephone]        # :alias => :tel

  property :formatted_name, String                        # :alias fn
  property :nickname, String                              # :alias nickname
  property :sort_string, String                           # :alias sort-string
  property :title, String
  property :note, String

  timestamps!

  ## Callbacks
  before_validate :format_name
  
  validates_presence_of :formatted_name

  view_by :formatted_name
  view_by :sort_string

  view_by :last_name,
    :map => 
      "function(doc) {
        if ((doc['couchrest-type'] == 'Schemas::VCard::VCard') && (doc.name.last_name)) { 
          emit(doc.name.last_name, 1);
          }
        }"
  
  view_by :organization,
    :map => 
      "function(doc) {
        if ((doc['couchrest-type'] == 'Schemas::VCard::VCard') && (doc.organization.name)) { 
          emit(doc.organization.name, 1);
          }
        }"

private
  def format_name
    self.formatted_name = ""
    self.formatted_name << "#{self.name.prefix}" unless self.name.prefix.blank?
    self.formatted_name << " #{self.name.first_name}" unless self.name.first_name.blank?
    self.formatted_name << " #{self.name.middle_name}" unless self.name.middle_name.blank?
    self.formatted_name << " #{self.name.last_name}" unless self.name.last_name.blank?
    self.formatted_name << " , #{self.name.suffix}" unless self.name.suffix.blank?

    self.formatted_name = self.formatted_name.strip
  end
end