require 'spec_helper'

describe Schema::TypesController do
  render_views

  before(:each) do
    reset_test_db!
    seed_test_db!
    @domain = create_test_domain
    integer_type = OpenMedia::Schema::Domain.default_types.find_type('integer')
    @string_type = OpenMedia::Schema::Domain.default_types.find_type('string')    
    @type = OpenMedia::Schema::Type.create!(:domain=>@domain, :name=>'MyTestType',
                                            :type_properties=>[{:name=>'Size', :expected_type=>integer_type},
                                                               {:name=>'Name', :expected_type=>@string_type}])
  end

  it 'should show type details page' do
    get :show, :domain_id=>@domain.id, :id=>@type.id
    response.should be_success
    response.should render_template('show')
    assert_select('tbody tr', :count=>2)
  end

  it 'should show type edit page' do
    get :edit, :domain_id=>@domain.id, :id=>@type.id
    response.should be_success
    response.should render_template('edit')
  end

  describe 'posting new type fields' do
    before(:each) do
      @domain.types.size.should == 1
      put :create, :domain_id=>@domain.id, :type=>{:name=>'My Type', :description=>'Type Description',
        :type_properties=>[{:name=>'Type Name',:expected_type_id=>@string_type.id}, {:name=>'', :expected_type_id=>'' }]}
    end

    it 'save new type' do
      response.should redirect_to schema_domain_path(@domain.id)
      assigns[:type].should_not be_new_record
      @domain.types.size.should == 2
    end

    it 'should ignore empty properties' do
      assigns[:type].type_properties.size.should == 1
    end      
  end


  it 'should allow types to be updated, and identifier updated if name changes' do
    put :update, :domain_id=>@domain.id, :id=>@type.id, :type=>{:name=>'New Name', :description=>'New Description'}
    response.should redirect_to schema_domain_type_path(@domain.id, @type.id)
    @type = OpenMedia::Schema::Type.get(@type.id)
    @type.identifier.should == 'new_name'   
  end
end
