QuoteFiles = %w(
  /usr/share/games/fortunes/songs-poems
  /usr/share/games/fortunes/wisdom
  /usr/share/games/fortunes/humorists
  /usr/share/games/fortunes/startrek
  /usr/share/games/fortunes/tao
  /usr/share/games/fortunes/computers
  /usr/share/games/fortunes/news
  /usr/share/games/fortunes/love
  /usr/share/games/fortunes/definitions
  /usr/share/games/fortunes/people
  /usr/share/games/fortunes/literature
  /usr/share/games/fortunes/ascii-art
  /usr/share/games/fortunes/linux
  /usr/share/games/fortunes/pets
  /usr/share/games/fortunes/sports
  /usr/share/games/fortunes/ethnic
  /usr/share/games/fortunes/food
  /usr/share/games/fortunes/knghtbrd
  /usr/share/games/fortunes/cookie
  /usr/share/games/fortunes/medicine
  /usr/share/games/fortunes/riddles
  /usr/share/games/fortunes/platitudes
  /usr/share/games/fortunes/perl
  /usr/share/games/fortunes/miscellaneous
  /usr/share/games/fortunes/goedel
  /usr/share/games/fortunes/men-women
  /usr/share/games/fortunes/zippy
  /usr/share/games/fortunes/fortunes
  /usr/share/games/fortunes/paradoxum
  /usr/share/games/fortunes/kids
  /usr/share/games/fortunes/education
  /usr/share/games/fortunes/drugs
  /usr/share/games/fortunes/magic
  /usr/share/games/fortunes/science
  /usr/share/games/fortunes/politics
  /usr/share/games/fortunes/linuxcookie
  /usr/share/games/fortunes/work
  /usr/share/games/fortunes/disclaimer
  /usr/share/games/fortunes/law
  /usr/share/games/fortunes/debian
  /usr/share/games/fortunes/translate-me
  /usr/share/games/fortunes/art
)

File.open(ARGV[0], "a") do |quotes_file|
  QuoteFiles.each do |filename|
    quotes = File.read(filename).split(/\n%\n/).map {|x| x.gsub(/\s+/, " ").strip }
    quotes.reject! { |q| q.length < 80 || q.length > 200 || q =~ /[\x00-\x1F]/ }
    quotes_file.puts quotes
  end
end
