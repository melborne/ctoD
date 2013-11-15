# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../spec_helper'

describe CtoD::DB do

  class Lang < ActiveRecord::Base
  end

  def delete_db_if_exist
    db_dir = '/tmp'
    db = File.join(db_dir, 'test.db')
    File.delete(db) if File.exist?(db)
  end

  def csvfile
    csv_dir = File.join(File.dirname(__FILE__), '..', 'fixtures')
    csv = File.join(csv_dir, 'langs.csv')
  end

  before do
    delete_db_if_exist
  end

  after do
    delete_db_if_exist
  end

  context 'create_table and table_exists? methods' do
    describe 'with csv filename and database uri' do
      it "should be success and db is empty" do
        conn = CtoD::DB.new(csv = csvfile, uri = 'sqlite3://localhost//tmp/test.db')
        conn.table_exists?.should be_false
        conn.create_table
        langs = Lang.all
        langs.length.should be 0
        conn.table_exists?.should be_true
      end
    end
  end

  context 'connect method' do
    describe 'with database uri' do
      it "should get URI::Generic class" do
        conn = CtoD::DB.connect('sqlite3://localhost//tmp/test.db')
        conn.class.should eql URI::Generic
      end
    end
  end

  context 'export method' do
    describe 'with csv filename and database uri' do
      it "should be export csv file to database" do
        conn = CtoD::DB.new(csv = csvfile, uri = 'sqlite3://localhost//tmp/test.db')
        conn.table_exists?.should be_false
        conn.create_table
        conn.export

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
end
