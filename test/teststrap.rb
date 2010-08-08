require 'rubygems'
require 'tempfile'
require 'fileutils'
require 'riot'
require 'mocha'

$LOAD_PATH << File.basename(__FILE__)
$LOAD_PATH << File.join(File.basename(__FILE__), '..', 'lib')
require 'q'

Riot.reporter = Riot::DotMatrixReporter
