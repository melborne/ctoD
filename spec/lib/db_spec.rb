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
        langs.length.should be 0
        conn.table_exists?.should be_true
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
        langs.length.should be 8

        lang = Lang.find(1)
        lang.year.should eql 1995
        lang.name.should eql "Ruby"
        lang.designer.should eql "Yukihiro Matsumoto"
        lang.predecessor.should eql "Smalltalk / Perl"

        lang = Lang.find(8)
        lang.year.should eql 1987
        lang.name.should eql "Erlang"
        lang.designer.should eql "Joe Armstrong"
        lang.predecessor.should eql "Prolog"
      end
    end
  end

  describe '#table_columns' do
    subject { conn.table_columns }

    let(:csvfile) { File.join(File.join(File.dirname(__FILE__), '..', 'fixtures'), 'langs.csv') }
    let(:db) { 'sqlite3://localhost//tmp/test.db' }
    let(:conn) { CtoD::DB.new( csv = csvfile, uri = db ) }

    it 'returns column name and type pairs in hash' do
      subject[:year].should eql :integer
      subject[:name].should eql :string
      subject[:designer].should eql :string
      subject[:predecessor].should eql :string
      subject[:date].should eql :date
      subject[:version].should eql :float
    end
  end

  describe '.build_columns' do
    subject { CtoD::DB.build_columns(csv) }

    let(:csvfile) { File.join(File.join(File.dirname(__FILE__), '..', 'fixtures'), 'langs.csv') }
    let(:csv) { CSV.table(csvfile) }

    it 'returns column name and type pairs in hash' do
      subject[:year].should eql :integer
      subject[:name].should eql :string
      subject[:designer].should eql :string
      subject[:predecessor].should eql :string
      subject[:date].should eql :date
      subject[:version].should eql :float
    end
  end

  after do
    delete_db_if_exist
  end
end
