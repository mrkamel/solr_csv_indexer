
require "test/unit"
require File.expand_path("../../lib/solr_csv_indexer", __FILE__)

module Net
  class HTTP
    def self.host
      @@host
    end

    def self.port
      @@port
    end

    def self.path
      @@path
    end

    def self.data
      @@data
    end

    def self.options
      @@options
    end

    def initialize(host, port)
      @@host = host
      @@port = port
    end

    def post(path, data, options)
      @@path = path
      @@data = data
      @@options = options

      Net::HTTPOK.new "1.0", 200, "OK"
    end
  end
end

class SolrCsvIndexerTest < Test::Unit::TestCase
  def setup
    header = ["test1", "test2"]

    @csv = SolrCsvIndexer.new(header, :limit => 2)
  end

  def test_h
    assert_equal "test1 test2 test3", @csv.send(:h, "test1,test2\ntest3")
  end

  def test_column
    @csv.column "a1,a2" # Again test whether h is invoked or not.
    @csv.column "b1"
    @csv.row

    @csv.column "a3"
    @csv.column "b2"
    @csv.row

    assert_equal "127.0.0.1", Net::HTTP.host
    assert_equal 8983, Net::HTTP.port
    assert_equal "/solr/update/csv", Net::HTTP.path
    assert_equal "test1,test2\na1 a2,b1\na3,b2\n", Net::HTTP.data
    assert_equal({ "content-type" => "text/csv; charset=utf-8" }, Net::HTTP.options)
  end

  def test_row
    # Already tested in test_column.
  end

  def test_upload
    # Already tested in test_column.
  end

  def test_finish
    @csv.finish

    assert_equal "<commit />", Net::HTTP.data
    assert_equal({ "content-type" => "text/xml" }, Net::HTTP.options)
  end

  def test_solr
    # Already tested in test_column.
  end

  def test_commit
    # Already tested in test_column.
  end
end

