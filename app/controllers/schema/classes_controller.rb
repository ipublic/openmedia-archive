class Schema::ClassesController < ApplicationController
  
  def autocomplete
    startkey = params[:term].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'')
    @uris = OpenMedia::Schema::RDFS::Class.prefix_search(startkey)
    render :json=>@uris.collect{|u| {:id=>u.to_s, :label=>u.to_s, :value=>(u.fragment || u.path.split('/').last)} }    
  end

end
