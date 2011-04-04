class Admin < CouchRest::Model::Base
  use_database SITE_DATABASE  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :registerable, :lockable and :timeoutable
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  property :site_id
  
  view_by :email
  view_by :confirmation_token
  view_by :site_id

  def self.find(id, opts=nil)
    puts "Admin.find, id: #{id}, opts: #{opts.inspect}"
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

  def site
    OpenMedia::Site.find(self.site_id)
  end
  

end

