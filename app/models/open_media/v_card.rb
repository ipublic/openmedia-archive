class OpenMedia::VCard < CouchRest::Model::Base
  
  use_database TYPES_DATABASE     # change to different DB?

  property :name, String          # :alias => :n
  property :full_name, String     # :alias => :fn
  property :first_name, String    # :alias => "given-name"
  property :middle_name, String   # :alias => "additional-name"
  property :last_name, String     # :alias => :family-name
  property :nickname, String      # :alias => :nickname
  property :prefix, String        # :alias => "honorific-prefix"
  property :suffix, String        # :alias => "honorific-suffix"
  property :job_title, String     # :alias => "Title"

  property :organization, OpenMedia::Organization                # :alias => :org
  property :email, [OpenMedia::Email]
  property :telephone, [OpenMedia::Telephone]   # alias => tel
  property :address, [OpenMedia::Address]       # alias => :adr

  timestamps!

  ## Callbacks
  before_validate :generate_full_name
  
  validates_presence_of :full_name
  
  view_by :full_name
  view_by :last_name
  
  view_by :organization,
    :map => 
      "function(doc) {
        if ((doc['couchrest-type'] == 'OmLinkedData::VCard') && (doc.organization.name)) { 
          emit(doc.organization.name, 1);
          }
        }"
  

#private
  def generate_full_name
    self.full_name = ""
    self.full_name << "#{self.prefix}" unless self.prefix.blank?
    self.full_name << " #{self.first_name}" unless self.first_name.blank?
    self.full_name << " #{self.middle_name}" unless self.middle_name.blank?
    self.full_name << " #{self.last_name}" unless self.last_name.blank?
    self.full_name << " #{self.suffix}" unless self.suffix.blank?

    self["full_name"] = self.full_name.strip
  end
end