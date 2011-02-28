module Admin::VcardsHelper
  def vcard_formatted_name(vcard)
    if vcard.n
      names= [vcard.n.honorific_prefix, vcard.n.given_name, vcard.n.additional_name, vcard.n.family_name, vcard.n.honorific_suffix]
      names.select{|p| !p.blank?}.join(' ')
    end
  end

  def vcard_label(vcard)
    [vcard_formatted_name(vcard), (vcard.org ? vcard.org.organization_name : nil)].select{|p| !p.blank?}.join(', ')
  end


  def type_options
    [['Work', RDF::VCARD.Work]]
  end

end
