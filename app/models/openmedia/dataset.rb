require 'openmedia/design'

class Openmedia::Dataset < Openmedia::Design
  use_database STAGING_DATABASE

  validates_presence_of :name
end
