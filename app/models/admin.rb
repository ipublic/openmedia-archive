class Admin < CouchRest::Model::Base
  use_database SITE_DATABASE  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :registerable, :lockable and :timeoutable
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :site, :class_name=>'OpenMedia::Site'  

  view_by :email
  view_by :confirmation_token
  view_by :site_id

  def self.find(id, opts=nil)
    if id == :first
      if opts[:conditions] && opts[:conditions][:id]
        self.find(opts[:conditions][:id])
      elsif opts[:conditions] && opts[:conditions][:email]
        self.find_by_email(opts[:conditions][:email])
      elsif opts[:conditions] && opts[:conditions][:confirmation_token]
        self.find_by_confirmation_token(opts[:conditions][:confirmation_token])
      end
    else
      super(id)
    end
  end

  def remember_created_at
    self['remember_created_at'].to_time if self['remember_created_at']
  end



end

