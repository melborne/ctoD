require 'csv'
require 'uri'
require 'active_record'
require 'mysql2'

module CtoD
  class DB
    AR = ActiveRecord::Base
    attr_accessor :string_size
    attr_reader :table_name, :class_name, :uri
    def initialize(csv, uri, string_size:100)
      @uri = URI.parse(uri)
      @table_name = File.basename(csv, '.csv').intern
      @class_name = @table_name[0..-2].capitalize
      @csv = CSV.table(csv)
      @string_size = string_size
      connect
    end

    def table_exists?
      AR.connection.table_exists?(@table_name)
    rescue => e
      puts e
    end

    def create_table
      conn = AR.connection
      conn.create_table(@table_name) do |t|
        @csv.headers.zip(column_types).each do |name, type|
          t.column name, type
        end
        t.timestamps
      end
    end

    def export
      self.class.const_set(@class_name, Class.new(AR))
      self.class.const_get(@class_name).create! @csv.map(&:to_hash)
    rescue => e
      puts "Something go wrong at export: #{e}"
    end

    private
    def connect
      settings = {
        adapter: @uri.scheme,
        host: @uri.host,
        username: @uri.user,
        password: @uri.password,
        database: @uri.path[1..-1],
        encoding: 'utf8'
      }
      AR.establish_connection(settings)
    rescue => e
      puts "Something go wrong at connect: #{e}"
    end

    def column_types
      @csv.first.to_hash.inject([]) do |mem, (k, v)|
        mem << begin
          case v
          when String, Symbol
            @csv[k].max_by(&:size).size > string_size ? :text : :string
          when Fixnum, Float
            @csv[k].any? { |e| e.is_a? Float } ? :float : :integer
          else
            v.class.name.downcase.intern
          end
        end
      end
    end
  end
end
