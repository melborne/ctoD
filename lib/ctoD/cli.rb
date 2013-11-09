require 'thor'

module CtoD
  class CLI < Thor
    desc "import CSV DATABASE", "Import CSV data to a DATABASE"
    option :string_size, aliases:"-s", default:100
    def import(from, to)
      db = create_table(from, to)
      db.import
      puts "CSV data imported successfully."
    end

    desc "create_table", "Create a database table for CSV"
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
  end
end
