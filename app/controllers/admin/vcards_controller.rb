class Admin::VcardsController < ApplicationController

  def index
    @vcards = vcard_model.each.to_a
  end

  def show
    @vcard = vcard_model.for(params[:id])
  end

  def new
    @vcard = vcard_model.new
  end


  def edit
  end

private
  def vcard_model
    vcard = OpenMedia::Schema::OWL::Class.for(RDF::VCARD.VCard).spira_resource
    vcard.default_source(OpenMedia::Site.instance.metadata_repository)
    vcard
  end
end
