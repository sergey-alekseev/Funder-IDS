require 'net/http'
require 'json'
require 'sheets'

TOP_LEVEL_FUNDERS = [
    100000133, 100000030, 100000180,
    100000005, 100000015, 100000201,
    100000140, 100000138, 100000139,
    100000038, 100000104, 100000002,
    100000161, 100000192, 100000001,
    100000014, 100000200, 100000199,
    100000738]

module Funders
  def new_funder(options = {})
    { id: 0,
      name: "",
      level: 0,
      parent_id: 0,
      descendants: [] }.merge options
  end

  def get_funder_and_its_descendants(funder_id, children_storage, level, parent_id=0)
    uri = URI("http://api.crossref.org/funders/10.13039/#{funder_id}")
    response = JSON.parse(Net::HTTP.get(uri))

    funder =  new_funder( id: funder_id,
                          name: response["message"]["name"],
                          level: level,
                          parent_id: parent_id)
    children_storage << funder

    children_ids = response["message"]["descendants"]
    children_ids.each do |child_id|
      get_funder_and_its_descendants(child_id, funder[:descendants], level+1, funder_id)
    end
  end

  def get_top_level_funders
    top_level = 0
    funders = []
    TOP_LEVEL_FUNDERS.each do |funder|
      get_funder_and_its_descendants(funder, funders, top_level)
    end
    funders
  end

  def render_top_level_funder funder, &block
    more = !funder[:descendants].empty?
    block.call(funder[:name], funder[:id], funder[:level], funder[:parent_id], more)
    funder[:descendants].each do |funder|
      render_top_level_funder(funder, &block)
    end
  end

  def render_top_level_funders funders, &block
    funders.each do |funder|
      render_top_level_funder(funder, &block)
    end
  end

  def recursive_get_descandants(funder)
    descendants = []
    funder[:descendants].each do |descendant|
        descendants <<  descendant
        descendants.concat recursive_get_descandants(descendant)
    end
    descendants
  end

  def to_table(top_level_funders)
    rows = []
    top_level_funders.each do |toplevel_funder|
      recursive_get_descandants(toplevel_funder).each do |descendant|
        rows << [toplevel_funder[:name], toplevel_funder[:id], descendant[:name], descendant[:id]]
      end
    end
    rows.uniq!.sort
  end

  def to_list(top_level_funders)
    rows = []
    top_level_funders.each do |toplevel_funder|
      rows << { name: toplevel_funder[:name], id: toplevel_funder[:id] }
      recursive_get_descandants(toplevel_funder).each do |descendant|
        rows << { name: descendant[:name], id: descendant[:id] }
      end
    end
    rows.uniq
  end

  def to_csv(table, file)
    CSV.open(file, "wb") do |csv|
      table.each do |row|
        csv << row
      end
    end
  end

  def get_funders_and_save(json_file, csv_file, xls_file)
    unless File.exists? json_file
      funders = get_top_level_funders
      File.write(json_file, Marshal.dump(funders))

      funders_table = to_table(funders)
      funders_sheet = Sheets::Base.new( [["TOP FUNDER NAME", "TOP FUNDER ID", "FUNDER NAME", "FUNDER ID"]].concat  funders_table)
      File.write(xls_file, funders_sheet.to_xls)
      to_csv(funders_table, csv_file)
    else
      funders = Marshal.load(File.read(json_file))
    end
    funders
  end
end

