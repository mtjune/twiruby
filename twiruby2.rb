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



# client.filter(:track => topics.join(",")) do |object|
#   print object.user.screen_name + " -> " + object.text + "\n" if object.is_a?(Twitter::Tweet)
# end


client.sample do |object|
  if object.is_a?(Twitter::Tweet)
    if /^[^(RT)].+(食べたい|たべたい)/ =~ object.text
      print object.user.screen_name + " -> " + object.text + "\n"
    end
  end
end
