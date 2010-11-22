module Admin::OrganizationsHelper
  def concat_organization_name_abbreviation(org)
    unless org.abbreviation.blank?
      result = org.name + ' (' + org.abbreviation + ')'
    else
      result = org.name
    end
  end

end
