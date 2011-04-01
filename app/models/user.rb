class User < CouchRest::Model::Base
  use_database SITE_DATABASE  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  view_by :email

  def self.find(id, conditions=nil)    
    if id == :first && conditions
      self.find_by_email(conditions['email'])
    else
      super
    end
  end

end

