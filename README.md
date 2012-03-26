
# SolrCsvIndexer

Simply batch index big csv data into solr.
Use if you have to index large amounts of structured data.

<pre>
  csv = SolrCsvIndexer.new(["field1", "field2"])

  csv.column "row1-column1"
  csv.column "row1-column2"
  csv.row

  csv.column "row2-column1"
  csv.column "row2-column2"

  ...

  csv.finish
</pre>

