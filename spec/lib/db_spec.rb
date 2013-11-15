# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../spec_helper'

describe CtoD::DB do

  def delete_db_if_exist
    db_dir = '.'
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

  context 'create_table and table_exists? method' do
    describe 'with database filename' do
      it "should be success" do
        conn = CtoD::DB.new(csv = csvfile, uri = 'sqlite3://localhost/tmp/test.db')
        conn.table_exists?.should be_false
        conn.create_table
        conn.table_exists?.should be_true
      end
    end
  end

  context 'connect method' do
    describe 'with database uri' do
      it "should be success" do
        conn = CtoD::DB.connect('sqlite3://localhost/tmp/test.db')
        conn.class.should eql URI::Generic
      end
    end
  end
end
