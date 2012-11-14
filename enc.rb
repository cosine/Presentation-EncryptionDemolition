#!/usr/bin/env ruby
#
# Usage:
#   enc aes-cbc key-or-passphrase-here iv-or-nonce plain text goes here
#   enc - aes-cbc key-or-passphrase-here iv-or-nonce cipher text goes here
#
# Arguments:
#   (1) algorithm-mode
#   (2) key or passphrase
#   (3) iv or nonce
#   (4+) plain or ciphertext
#
# Valid algorithm-modes:
#   aes-128-ecb
#   aes-128-cbc
#   aes-128-ctr

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

module Enc
  def self.run (argv, input = $stdin)
    argv = argv.dup

    if argv[0] == "-"
      encrypt = :decrypt
      argv.shift
    else
      encrypt = :encrypt
    end

    cipher = OpenSSL::Cipher.new(argv[0])
    cipher.send(encrypt)  # set encryption/decryption direction
    # salt equals password into the key generation because we need this to be deterministic.
    cipher.key = OpenSSL::PKCS5.pbkdf2_hmac(argv[1], argv[1], 20000, 64, OpenSSL::Digest::SHA512.new)

    # Get iv and input data from argv if there, or get from stdin if necessary
    inputdata = argv[3..-1]
    if inputdata.empty?
      inputdata = input.read
    else
      inputdata = inputdata.join(" ")
    end

    # On decryption we require hex input.  Change it to binary.
    inputdata = inputdata.gsub(/\s+/, "").ynhex if encrypt == :decrypt

    # IV is always in hex when given.  Change it to binary.
    # Gen random IV if given "-".
    if argv[2] == "-"
      iv = cipher.random_iv
    else
      iv = cipher.iv = argv[2].ynhex
    end

    outputdata = cipher.update(inputdata) << cipher.final

    # Output in hex, with IV, if in encrypt mode.
    if encrypt == :encrypt
      outputdata = iv + outputdata
      puts outputdata.hexy.scan(/.{1,8}/).join(" ")
    else
      puts outputdata
    end
  end
end

if __FILE__ == $0
  Enc.run(ARGV)
end
