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
nonce = OpenSSL::Random.random_bytes(16)

quotes_file = File.join(File.dirname($0), "quotations.txt")
random_quotes = File.read(quotes_file).split(/\n/).
    sort_by { OpenSSL::Random.random_bytes(3) }[0, 12].
    sort_by(&:length)

ciphertexts = random_quotes.map do |plaintext|
  cipher = OpenSSL::Cipher.new("aes-128-ctr")
  cipher.encrypt
  cipher.key = key
  cipher.iv = nonce
  cipher.update(plaintext) << cipher.final
end


puts "Challenge: decrypt the first ciphertext"
puts "Weakness: all ciphertexts encrypted with the same keystream"
puts

ciphertexts.each do |ciphertext|
  puts ciphertext.hexy.scan(/.{1,32}/).join(" ")
end


cipher = OpenSSL::Cipher.new("aes-128-ctr")
cipher.encrypt
cipher.key = key
cipher.iv = nonce
keystream = cipher.update("\0" * random_quotes.map(&:length).max) << cipher.final

$stderr.puts "Answers for keystream reuse challenge."
$stderr.puts
$stderr.puts "Keystream: #{keystream.hexy.scan(/.{1,32}/).join(" ")}"
$stderr.puts
random_quotes.each { |quote| $stderr.puts quote }

