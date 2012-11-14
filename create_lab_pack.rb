#!/usr/bin/env ruby
#
# Usage: $0 <basename> <start num> <number output>

if ARGV.length != 3
  puts "barf, please read usage"
end

basename = ARGV[0]
start = ARGV[1].to_i
quantity = ARGV[2].to_i

quantity.times do |index|
  number = start + index
  fbase = "#{basename}-#{number}"

  system("mkdir #{fbase}")
  system("ruby lab1/create_pack1.rb >#{fbase}/lab1.txt 2>#{fbase}/lab1-answer.txt")
  system("ruby lab2/create_pack2.rb >#{fbase}/lab2.txt 2>#{fbase}/lab2-answer.txt 3>#{fbase}/check_answer2.rb")
  system("zip -r9 #{fbase}-answers.zip #{fbase}")
  system("rm #{fbase}/*-answer.txt")
  system("zip -r9 #{fbase}.zip #{fbase}")
  system("rm -rf #{fbase}")
end
