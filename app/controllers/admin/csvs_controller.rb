require 'fastercsv'

class Admin::CsvsController < ApplicationController
  
  def show
    @import_table = []
    @import_cells = @import_table.import_cells
    @row_index_max = @import_cells.map { |cell| cell.row_index }.max
    @column_index_max = @import_cells.map { |cell| cell.column_index }.max
  end

  def import
  end

  def upload
    table = ImportTable.new 
    row_index = 0
    CSV.parse(params[:upload][:csv]) do |cells|
      column_index = 0
      cells.each do |cell|
        table.import_cells.build :column_index => column_index, :row_index => row_index, :contents => cell
        column_index += 1
      end
      row_index += 1
    end
    table.save
    redirect_to import_table_path(table)
    
    # render :text => params[:upload][:csv].original_path.to_json
    # render :text => params.to_json
    # raise params.to_yaml
  end
  
  def merge
  end

end
