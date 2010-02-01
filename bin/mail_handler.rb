#!/usr/bin/ruby
require 'net/http'
require 'uri'

Net::HTTP.post_form(URI.parse('http://localhost:3000/emails'), {"email" => STDIN.read})

