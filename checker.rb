require 'open-uri'
require 'json'
require 'yaml'

class Array
  def to_ranges
    array = self.compact.uniq.sort
    ranges = []
    if !array.empty?
      # Initialize the left and right endpoints of the range
      left, right = self.first, nil
      array.each do |obj|
        # If the right endpoint is set and obj is not equal to right's successor
        # then we need to create a range.
        if right && obj != right.succ
          if left == right
            ranges << left
          elsif left+1==right
            ranges << left
            ranges << right
          else
            ranges << Range.new(left,right)
          end
          left = obj
        end
        right = obj
      end
      if left == right
        ranges << left
      elsif left+1==right
        ranges << left
        ranges << right
      else
        ranges << Range.new(left,right)
      end
    end
    ranges
  end
end

# puts "| orgán | rok | nejvyšší číslo | počet | duplicitních | chybí v řadě |"
puts "| orgán | rok | duplicitních | chybí v řadě |"
puts "| --- | --- | --- | --- |"
Dir.glob("source/usn*.json").sort.each{|f|
  d=JSON.load(File.read(f)).collect{|a| a['cislo_usneseni'].split('/')[0].to_i}
  _, organ, rok = f.match(/source\/usneseni_(zastupitelstvo|rada)_(\d{4}).json/).to_a
  # puts "| #{organ} | #{rok} | #{d.max} | #{d.size} | **#{d.size-d.uniq.size}** : #{d.select{ |e| d.count(e) > 1 }.uniq.sort.to_ranges.join(',')} | **#{d.max-d.uniq.size}** : #{((1..d.max).to_a-d).to_ranges.join(',')} |"
  # puts "| #{organ} | #{rok} | **#{d.size-d.uniq.size}** : #{d.select{ |e| d.count(e) > 1 }.uniq.sort.to_ranges.join(',')} | **#{d.max-d.uniq.size}** : #{((1..d.max).to_a-d).to_ranges.join(',')} |"
  puts "| #{organ} | #{rok} | #{d.max} |"
  if File.exist?("usneseni-master/usneseni_#{organ}_#{rok}.json")
    d_old = JSON.load(File.read("usneseni-master/usneseni_#{organ}_#{rok}.json")).collect{|a| a['number_int'].to_i}
    # puts "| #{organ.upcase} | #{rok} | #{d_old.max} | #{d_old.size} : **#{d_old.size-d_old.uniq.size}** : #{d_old.select{ |e| d_old.count(e) > 1 }.uniq.sort.to_ranges.join(',')} | **#{d_old.max-d_old.uniq.size}** | #{((1..d_old.max).to_a-d_old).to_ranges.join(',')} |"
    # puts "| #{organ.upcase} | #{rok} | **#{d_old.size-d_old.uniq.size}** : #{d_old.select{ |e| d_old.count(e) > 1 }.uniq.sort.to_ranges.join(',')} | **#{d_old.max-d_old.uniq.size}** : #{((1..d_old.max).to_a-d_old).to_ranges.join(',')} |"
    puts "| #{organ.upcase} | #{rok} | #{d_old.max} |"
  end
}
