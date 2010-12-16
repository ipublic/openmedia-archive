require 'spec_helper'

describe OpenMedia::ETL::Control::DatasetDestination do
  it 'should require :dataset in configuration'
  it 'should require :order in mapping'
  it 'should require dataset in :dataset to actually exist'
  it 'should flush data by creating dataset model documents and sending to couchdb/_bulk_docs'  
end
