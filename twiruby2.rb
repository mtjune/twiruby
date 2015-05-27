#!/usr/bin/ruby

require 'twitter'
require "./config.rb"
include Twikeys


client = Twitter::Streaming::Client.new do |config|
	config.consumer_key = Twikeys::Consumer_key
	config.consumer_secret = Twikeys::Consumer_secret
	config.access_token = Twikeys::Access_token
	config.access_token_secret = Twikeys::Access_token_secret
end

print Twikeys::Consumer_key + "\n"
print Twikeys::Consumer_secret + "\n"
print Twikeys::Access_token + "\n"
print Twikeys::Access_token_secret + "\n"


client.sample do |object|
	puts object.text if object.is_a?(Twitter::Tweet)
end

