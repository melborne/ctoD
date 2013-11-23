# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../spec_helper'

describe CtoD::DB do

  class Lang < ActiveRecord::Base; end

  def delete_db_if_exist
    db = File.join('/tmp', 'test.db')
    File.delete(db) if File.exist?(db)
  end

  before do
    delete_db_if_exist
  end

  describe '#create_table and #table_exists?' do
    context 'with csv filename and database uri' do
      subject { conn.create_table }

      let(:csvfile) { File.join(File.join(File.dirname(__FILE__), '..', 'fixtures'), 'langs.csv') }
      let(:db) { 'sqlite3://localhost//tmp/test.db' }
      let(:conn) { CtoD::DB.new( csv = csvfile, uri = db ) }

      it 'should be success and db is empty' do
        subject
        langs = Lang.all
        expect(langs.length).to eq 0
        expect(conn.table_exists?).to be_true
      end
    end
  end

  describe '.connect' do
    context 'with database uri' do
      subject {
        conn = CtoD::DB.connect( uri = db )
        conn.class
      }

      let(:db) { 'sqlite3://localhost//tmp/test.db' }

      it { expect(subject).to eql URI::Generic }
    end
  end

  describe '#export' do
    context 'with csv filename and database uri' do

      subject {
        conn.create_table
        conn.export
      }

      let(:csvfile) { File.join(File.join(File.dirname(__FILE__), '..', 'fixtures'), 'langs.csv') }
      let(:db) { 'sqlite3://localhost//tmp/test.db' }
      let(:conn) { CtoD::DB.new( csv = csvfile, uri = db ) }

      it "should be export csv file to database" do
        subject
        langs = Lang.all
        expect(langs.length).to eq 8

        lang = Lang.find(1)
        expect(lang.year).to eq 1995
        expect(lang.name).to eq "Ruby"
        expect(lang.designer).to eq "Yukihiro Matsumoto"
        expect(lang.predecessor).to eq "Smalltalk / Perl"

        lang = Lang.find(8)
        expect(lang.year).to eq 1987
        expect(lang.name).to eq "Erlang"
        expect(lang.designer).to eq "Joe Armstrong"
        expect(lang.predecessor).to eq "Prolog"
      end
    end
  end

  describe '#table_columns' do
    subject { conn.table_columns }

    let(:csvfile) { File.join(File.join(File.dirname(__FILE__), '..', 'fixtures'), 'langs.csv') }
    let(:db) { 'sqlite3://localhost//tmp/test.db' }
    let(:conn) { CtoD::DB.new( csv = csvfile, uri = db ) }

    it 'returns column name and type pairs in hash' do
      expect(subject[:year]).to be :integer
      expect(subject[:name]).to be :string
      expect(subject[:designer]).to be  :string
      expect(subject[:predecessor]).to be :string
      expect(subject[:date]).to be :date
      expect(subject[:version]).to be :float
    end
  end

  describe '.build_columns' do
    subject { CtoD::DB.build_columns(csv) }

    let(:csvfile) { File.join(File.join(File.dirname(__FILE__), '..', 'fixtures'), 'langs.csv') }
    let(:csv) { CSV.table(csvfile) }

    it 'returns column name and type pairs in hash' do
      expect(subject[:year]).to be :integer
      expect(subject[:name]).to be :string
      expect(subject[:designer]).to be :string
      expect(subject[:predecessor]).to be :string
      expect(subject[:date]).to be :date
      expect(subject[:version]).to be :float
    end
  end

  after do
    delete_db_if_exist
  end
end
