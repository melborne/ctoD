require 'thor'
require 'csv'

module CtoD
  class CLI < Thor
    desc "export CSV DATABASE", "Export CSV data to DATABASE"
    option :string_size, aliases:"-s", default:100
    def export(from, to)
      db = create_table(from, to)
      db.export
      puts "CSV data exported successfully."
    end

    desc "create_table CSV DATABASE", "Create a database table for CSV"
    option :string_size, aliases:"-s", default:100
    def create_table(from, to)
      db = DB.new(from, to, string_size: options[:string_size])
      if db.table_exists?
        puts "Table '#{db.table_name}' exsist."
      else
        db.create_table
        puts "Table '#{db.table_name}' created at #{db.uri}."
      end
      db
    end

    desc "table_columns CSV", "Show column name and type pairs for a table based on given CSV"
    option :string_size, aliases:"-s", default:100
    def table_columns(csv)
      csv_data = CSV.table(csv, header_converters:->h{h.strip})
      columns = DB.build_columns(csv_data, string_size: options[:string_size])
      puts "\e[32mcolumn name\e[0m :type"
      puts "----------------------------"
      puts columns.map { |name_type| "\e[32m%s\e[0m :%s" % name_type }
    end

    desc "version", "Show CtoD version"
    def version
      puts "CtoD #{CtoD::VERSION} (c) 2013 kyoendo"
    end
    map "-v" => :version
  end
end
