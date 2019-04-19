require 'open-uri'
require 'json'
require 'yaml'

Dir.glob("source/usn*2*.json").sort.each{|f|
  d=JSON.load(File.read(f)).collect{|a| a['cislo_usneseni'].split('/')[0].to_i}
  puts "#{f}: #{(1..d.max).to_a-d}"
}
