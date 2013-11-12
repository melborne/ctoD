require 'csv'
require 'uri'
require 'active_record'

module CtoD
  class DB
    include ActiveSupport::Inflector
    AR = ActiveRecord::Base
    attr_accessor :string_size
    attr_reader :table_name, :class_name, :uri
    def initialize(csv, uri, string_size:100)
      @table_name = File.basename(csv, '.csv').intern
      @class_name = singularize(@table_name).capitalize
      @csv = CSV.table(csv)
      @string_size = string_size
      @uri = DB.connect(uri)
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

    def self.connect(uri)
      uri = URI.parse(uri)
      uri.scheme = 'postgresql' if uri.scheme=='postgres'
      settings = {
        adapter: uri.scheme,
        host: uri.host,
        username: uri.user,
        password: uri.password,
        database: uri.path[1..-1],
        encoding: 'utf8'
      }
      AR.establish_connection(settings)
      uri
    rescue => e
      puts "Something go wrong at connect: #{e}"
    end

    private
    def column_types
      is_date = /^\s*\d{1,4}(\-|\/)?\d{1,2}(\-|\/)?\d{1,2}\s*$/
      @csv.first.to_hash.inject([]) do |mem, (k, v)|
        mem << begin
          case v
          when 'true', 'false'
            :boolean
          when is_date
            :date
          when String, Symbol
            @csv[k].compact.max_by(&:size).size > string_size ? :text : :string
          when Fixnum, Float
            @csv[k].any? { |e| e.is_a? Float } ? :float : :integer
          when NilClass
            :string
          else
            v.class.name.downcase.intern
          end
        end
      end
    end
  end
end
