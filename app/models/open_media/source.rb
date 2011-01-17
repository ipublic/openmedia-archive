class OpenMedia::Source < Hash

  FILE_TYPE = 'file'
  DATABASE_TYPE = 'database'

  TYPES = [FILE_TYPE]
  
  DELIMITED_PARSER = 'delimited'
  FIXED_WIDTH_PARSER = 'fixed_width'
  SAX_PARSER = 'sax'
  XML_PARSER = 'xml'

  PARSERS  = [DELIMITED_PARSER] 

  include CouchRest::Model::CastedModel  

  property :source_type
  property :parser  
  property :column_separator    # separator for delimited parser
  property :skip_lines, Integer # lines to skip (i.e. header rows) for delimited parser
  property :source_properties, [OpenMedia::Schema::Property]
end
