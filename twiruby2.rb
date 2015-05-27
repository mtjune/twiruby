#!/usr/bin/ruby

require "tweetstream"
require "./config.rb"
include Client

keys = get_keys()

TweetStream.configure do |config|
	config.consumer_key = keys["consumer_key"]
	config.consumer_secret = keys["consumer_secret"]
	config.oauth_token = keys["access_token"]
	config.oauth_token_secret = keys["access_token_secret"]
	config.auth_method = :oauth
end


client = TweetStream::Client.new
client.userstream do |status|
	puts " #{status.user.name} -> #{status.text}\n\n"
end

