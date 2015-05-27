#!/usr/bin/ruby

require 'twitter'
require "./config.rb"
include Twikeys

client = Twitter::REST::Client.new do |config|
  config.consumer_key     = Twikeys::Consumer_key
  config.consumer_secret  = Twikeys::Consumer_secret
end

# def collect_with_max_id(collection=[], max_id=nil, &block)
#   response = yield(max_id)
#   collection += response
#   response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
# end
#
# def client.get_all_tweets(user)
#   collect_with_max_id do |max_id|
#     options = {count: 20, include_rts: true}
#     options[:max_id] = max_id unless max_id.nil?
#     user_timeline(user, options)
#   end
# end
#
# client.get_all_tweets("mtjune11")

client.search("食べたい", result_type: "recent").take(20).each do |tweet|
  puts "#{tweet.text}"
end
