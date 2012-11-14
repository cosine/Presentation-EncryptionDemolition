#!/usr/bin/env ruby

require "openssl"

class String
  # "41" --> "A"
  def ynhex
    [self].pack("H*")
  end

  # "A" --> "41"
  def hexy
    unpack("H*").first
  end
end

key = OpenSSL::Random.random_bytes(16)
iv = OpenSSL::Random.random_bytes(16)

plaintext = "Send 00010000 dollars to Michael."

cipher = OpenSSL::Cipher.new("aes-128-cbc")
cipher.encrypt
cipher.key = key
cipher.iv = iv
ciphertext = cipher.update(plaintext) << cipher.final

puts "Challenge: change the ciphertext to give Michael 99999999 dollars"
puts "Weakness: CBC mode encryptions can be tampered by flipping bits"
puts
puts "Plaintext: #{plaintext}"
print "Ciphertext: #{iv.hexy} "
puts ciphertext.hexy.scan(/.{1,32}/).join(" ")
puts
puts "Verify answers by running: ruby check_answer2.rb <answer ciphertext>"


answer_plaintext = "Send 99999999 dollars to Michael."
answer_iv = (iv.hexy.to_i(16) ^ "00000000000909090809090909000000".to_i(16)).to_s(16).ynhex

cipher = OpenSSL::Cipher.new("aes-128-cbc")
cipher.encrypt
cipher.key = key
cipher.iv = answer_iv
answer_ciphertext = cipher.update(answer_plaintext) << cipher.final

$stderr.puts "Answer for ciphertext tampering lab."
$stderr.puts
$stderr.puts "Plaintext: #{plaintext}"
$stderr.print "Ciphertext: #{iv.hexy} "
$stderr.puts ciphertext.hexy.scan(/.{1,32}/).join(" ")
$stderr.puts
$stderr.puts "Encryption Key: #{key.hexy}"
$stderr.print "Answer Ciphertext: #{answer_iv.hexy} "
$stderr.puts answer_ciphertext.hexy.scan(/.{1,32}/).join(" ")

answer_ciphertext_hash = OpenSSL::Digest::SHA512.new.update(answer_ciphertext).hexdigest

check_fd = IO.new(3, "w")
check_fd.puts <<__EOF__
#!/usr/bin/env ruby
require "openssl"

class String
  # "41" --> "A"
  def ynhex
    [self].pack("H*")
  end

  # "A" --> "41"
  def hexy
    unpack("H*").first
  end
end

attempted = ARGV.join.gsub(/\\s+/, "").ynhex
answer_hash = #{answer_ciphertext_hash.inspect}
if answer_hash == OpenSSL::Digest::SHA512.new.update(attempted).hexdigest
  puts "Winner!"
else
  puts "Keep trying!"
end
__EOF__
