# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

name = VCard::Name.new(:first_name => "Dan", :last_name => "Thomas")
email1 = VCard::Email.new(:type => "Work", :value => "dan.thomas@ipublic.org")
email2 = VCard::Email.new(:type => "Home", :value => "geoobject@gmail.com")
org = VCard::Organization.new(:name => "iPublic.org")
vcard = VCard::VCard.new(:name => name, :organization => org, :title => "Chief Technology Officer")
vcard.emails << email1 << email2
vcard.save!

# create om site w/ dan as admin
ec = OpenMedia::NamedPlace.new(:name => "Ellicott City", 
                               :state_abbreviation=>"MD",
                               :geometries => [
                                 GeoJson::Geometry.new(:coordinates=>[-76.83419, 39.2722118], :type=>"Point")]
                               )
                                
@om_site = OpenMedia::Site.create!(:identifier => "om", 
                                :openmedia_name => 'iPublic OpenMedia Portal', 
                                :welcome_banner => "Civic OpenMedia", 
                                :welcome_message => "A publishing system for government open data",
                                :municipality => ec)
# @om_site.initialize_metadata

dan = Admin.new(:email => email1.value, 
            :password => 'ChangeMe',
            :password_confirmation => 'ChangeMe', 
            :site => @om_site, 
            :confirmed_at => Time.now).save!

require File.join(File.dirname(__FILE__),'seeds', 'collections')
require File.join(File.dirname(__FILE__),'seeds', 'vocabularies', 'xml_schema')
require File.join(File.dirname(__FILE__),'seeds', 'vocabularies', 'geo_json')
require File.join(File.dirname(__FILE__),'seeds', 'vocabularies', 'geo')
require File.join(File.dirname(__FILE__),'seeds', 'vocabularies', 'municipality')
require File.join(File.dirname(__FILE__),'seeds', 'vocabularies', 'vcard')


d = OpenMedia::Dashboard.new({:title => "MiDashboard"})
g = OpenMedia::DashboardGroup.new({:title => "Economic Strength"})
g.measures << {:measure => 'Gross Domestic Product (GDP) Growth', 
               :description => 'Economic growth is often measured as the rate of change in per capita gross domestic product (GDP). The GDP refers only to the quantity of goods and services produced. A growing GDP means the economy is expanding, while negative numbers mean the economy is shrinking.',
               :om_source_class => '', 
               :om_source_property => '',
               :measure_source_organization => '',  #metadata publisher?
               :measure_source_url => '',
               :values => [-2.0,0.4,-2.7,-5.2],
               :format => 'percentage',
               :visual => 'inlinesparkline', 
               :rank => 49}
               
g.measures << {:measure => 'Unemployment',
               :description => 'Unemployment figures measure the number of people without jobs who are actively seeking work. These numbers also reflect the success of the economy in providing opportunities for Michigan residents to support themselves and their families.',
               :om_source_class => '', 
               :om_source_property => '',
               :measure_source_organization => '',
               :measure_source_url => '',
               :values => [14.1,14,13.6,13.2,13.1,13.1,13.0,12.8,12.4,11.7,10.7,10.4],
               :format => 'percentage',
               :visual => 'inlinesparkline', 
               :rank => 45}
               
g.measures << {:measure => 'Children living in poverty',
              :description => 'Across the nation, families are struggling to make ends meet. Many parents are unable to provide their children with the basic food, clothing and medical care they need. Children who live in poverty are more likely to have low academic achievement and health, behavioral and emotional problems. This measure shows the share of children under age 18 who live in families with incomes below the federal poverty level, as defined by the U.S. Office of Management and Budget. ',
              :om_source_class => '', 
              :om_source_property => '',
              :measure_source_organization => '',
              :measure_source_url => '',
              :values => [23,77],
              :format => 'percentage',
              :visual => 'pie', 
              :rank => 38}

g.measures << {:measure => 'Real personal income per capita',
              :description => "This is Michigan's real personal income per capita, adjusted for inflation. In general, per capita income in Michigan has not kept up with inflation over the past few years. Real personal income per capita includes wages and salaries, transfer payments, dividends, interest and rental income. As income rises, individuals are better able to provide for their families, buy homes and improve their quality of life",
              :om_source_class => '', 
              :om_source_property => '',
              :measure_source_organization => '',
              :measure_source_url => '',
              :values => [29392,29150,28901,29219,28862,28465,28369,28426,28250,27558],
              :format => 'currency',
              :visual => 'inlinesparkline', 
              :rank => 37}
               
d.groups << g

g = OpenMedia::DashboardGroup.new({:title => "Health and Education"})
g.measures = [] # Override behavior where new instance isn't clearing measures array
g.measures << {:measure => 'Infant mortality (per 1,000 births)', 
               :om_source_class => '', 
               :om_source_property => '',
               :measure_source_organization => "America's Health Rankings",
               :measure_source_url => 'http://www.americashealthrankings.org/Measure/2010/zUS/Infant%20Mortality.aspx',
               :values => [8.2,7.8,7.8,7.6,7.6,7.7],
               :format => 'percentage',
               :visual => 'inlinesparkline', 
               :rank => 37}
               
g.measures << {:measure => 'Obesity in the population', 
               :om_source_class => '', 
               :om_source_property => '',
               :measure_source_organization => 'Centers for Disease Control and Prevention',
               :measure_source_url => 'http://apps.nccd.cdc.gov/BRFSS/',
               :values => [26.2, 28.8, 28.2, 29.5, 30.3],
               :format => 'percentage',
               :visual => 'inlinesparkline', 
               :rank => 40}

g.measures << {:measure => '3rd graders reading at grade level', 
             :om_source_class => '', 
             :om_source_property => '',
             :measure_source_organization => "",
             :measure_source_url => '',
             :values => [87,87,86,87,90],
             :format => 'percentage',
             :visual => 'inlinebar', 
             :rank => ''}
             
g.measures << {:measure => 'College readiness', 
            :om_source_class => '', 
            :om_source_property => '',
            :measure_source_organization => "",
            :measure_source_url => '',
            :values => [10,12,12,9,7],
            :format => 'number',
            :visual => 'bullet', 
            :rank => '46'}

d.groups << g

g = OpenMedia::DashboardGroup.new({:title => "Value for Money Government"})
g.measures = [] # Override behavior where new instance isn't clearing measures array
g.measures << {:measure => "Bond rating (Standard and Poor's)", 
               :om_source_class => '', 
               :om_source_property => '',
               :measure_source_organization => "",
               :measure_source_url => '',
               :values => ['AA-', 'AA-'],
               :format => 'string',
               :visual => '', 
               :rank => ''}
               
g.measures << {:measure => 'Property Crime per 100,000', 
              :om_source_class => '', 
              :om_source_property => '',
              :measure_source_organization => "",
              :measure_source_url => '',
              :values => [3091,3213,3066,2935,2838],
              :format => 'number',
              :visual => 'inlinebar', 
              :rank => ''}
d.groups << g

g = OpenMedia::DashboardGroup.new({:title => "Quality of Life"})
g.measures = [] # Override behavior where new instance isn't clearing measures array
g.measures << {:measure => 'State park popularity - annual visits per citizen', 
               :om_source_class => '', 
               :om_source_property => '',
               :measure_source_organization => "",
               :measure_source_url => '',
               :values => [2.26,2.21,2.17,2.12,2.12,2.15],
               :format => 'number',
               :visual => 'inlinebar', 
               :rank => ''}
               
g.measures << {:measure => 'Population growth (ages 25-34)', 
              :om_source_class => '', 
              :om_source_property => '',
              :measure_source_organization => "",
              :measure_source_url => '',
              :values => [0.6,-0.1,-0.3,0.3,-0.6,-0.8,-1.2,-1.7,-1.9,-1.6],
              :format => 'percentage',
              :visual => 'inlinebar', 
              :rank => ''}
d.groups << g

g = OpenMedia::DashboardGroup.new({:title => "Public Safety"})
g.measures = [] # Override behavior where new instance isn't clearing measures array
g.measures << {:measure => 'Violent Crime per 100,000', 
               :om_source_class => '', 
               :om_source_property => '',
               :measure_source_organization => "",
               :measure_source_url => '',
               :values => [552,562,536,501,497],
               :format => 'number',
               :visual => 'inlinebar', 
               :rank => '38'}
               
g.measures << {:measure => 'Property Crime per 100,000', 
              :om_source_class => '', 
              :om_source_property => '',
              :measure_source_organization => "",
              :measure_source_url => '',
              :values => [3091,3213,3066,2935,2838],
              :format => 'number',
              :visual => 'inlinebar', 
              :rank => '25'}

g.measures << {:measure => 'Traffic Injuries - Fatal', 
              :om_source_class => '', 
              :om_source_property => '',
              :measure_source_organization => "",
              :measure_source_url => '',
              :values => [1129,1084,1084,980,871],
              :format => 'number',
              :visual => 'inlinebar', 
              :rank => ''}

g.measures << {:measure => 'Traffic Injuries - Serious and Fatal', 
              :om_source_class => '', 
              :om_source_property => '',
              :measure_source_organization => "",
              :measure_source_url => '',
              :values => [8486,7618,7485,6725,6511],
              :format => 'number',
              :visual => 'inlinebar', 
              :rank => ''}


d.groups << g
d.save
