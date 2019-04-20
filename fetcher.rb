#!/usr/bin/env ruby
require 'open-uri'
require 'json'
require 'yaml'

{
  "rada" => 1..2,#1..512,
  "zastupitelstvo" => 1..4, #1..128
}.each{|organ, rozsah|
  rozsah.to_a.each do |i|
    puts "Fetching #{organ} #{i}/#{rozsah.last}"
    begin
      zasedanis = JSON.load(open("https://www.praha7.cz/api/#{organ}/usneseni?p=#{i}"))
    rescue
      "ERROR"
    else
      puts "Found #{zasedanis.size} records"
      zasedanis.each{|zasedani|
        rok = zasedani['datum_vzniku_usneseni'][0..3]
        filename = "source/usneseni_#{organ}_#{rok}.json"
        previous = File.exist?(filename) ? JSON.load(File.read(filename)) : []
        File.open(filename,"w"){|f| f <<
          # JSON.pretty_generate(previous.push(zasedani).uniq.sort{|a,b| a['cislo_usneseni']<=>b['cislo_usneseni']})
          # docasna deduplikace
          JSON.pretty_generate(previous.push(zasedani).sort{|a,b| a['cislo_usneseni']<=>b['cislo_usneseni']}.reverse.uniq{|e| e['cislo_usneseni']}.reverse)
        }
      }
    end
  end
}

File.open('source/zasedani_zastupitelstvo.json',"w"){|f| f <<
  JSON.pretty_generate(JSON.load(open("https://www.praha7.cz/api/zastupitelstvo/zasedani")))
}
