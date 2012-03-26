
$:.push File.expand_path("../lib", __FILE__)
require "solr_csv_indexer/version"

Gem::Specification.new do |s|
  s.name        = "solr_csv_indexer"
  s.version     = SolrCsvIndexer::VERSION
  s.authors     = ["Benjamin Vetter"]
  s.email       = ["vetter@flakks.com"]
  s.homepage    = ""
  s.summary     = %q{Batch index csv data into solr.}
  s.description = %q{Simply batch index big csv data into solr.}

  s.rubyforge_project = "solr_csv_indexer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
end
