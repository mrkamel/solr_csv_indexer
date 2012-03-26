
require "solr_csv_indexer/version"
require "net/http"

class SolrCsvIndexer
  def initialize(header, options = {})
    @header = header

    uri = URI.parse(options[:url] || "http://127.0.0.1:8983/solr")

    @solr_host = uri.host
    @solr_port = uri.port

    @limit = options[:limit] || 50_000

    @data = "#{@header.join(",")}\n"

    @rows = 0
    @columns = 0
  end

  def column(data)
    @data << "," unless @columns.zero?

    @data << h(data)

    @columns += 1
  end

  def row
    @data << "\n"

    @columns = 0
    @rows += 1

    upload if @rows >= @limit
  end

  def finish
    upload
    commit
  end

  private

  def h(str)
    str.to_s.gsub(/[,\n\r]+/, " ")
  end

  def upload
    solr

    @data = "#{@header.join(",")}\n"

    @rows = 0
  end

  def solr
    http = Net::HTTP.new(@solr_host, @solr_port)

    response = http.post("/solr/update/csv", @data, "content-type" => "text/csv; charset=utf-8")

    raise "Solr responded with an http error code #{response.code}: #{response.body}" unless response.is_a?(Net::HTTPOK)
  end

  def commit
    http = Net::HTTP.new(@solr_host, @solr_port)

    response = http.post("/solr/update", "<commit />", "content-type" => "text/xml")

    raise "Solr responded with an http error code #{response.code}: #{response.body}" unless response.is_a?(Net::HTTPOK)
  end
end

