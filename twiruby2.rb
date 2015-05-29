#!/usr/bin/ruby

require 'rubygems'
require 'twitter'
require 'mongo'
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

# client.sample do |object|
#   if object.is_a?(Twitter::Tweet)
#     if /^[^(RT)].+(食べたい|たべたい)/ =~ object.text
#       print object.user.screen_name + " -> " + object.text + "\n"
#     end
#   end
# end


class Tweet_Collector
  def initialize()

		@count = 0

    @client = Twitter::Streaming::Client.new do |config|
			config.consumer_key = Twikeys::Consumer_key
			config.consumer_secret = Twikeys::Consumer_secret
			config.access_token = Twikeys::Access_token
			config.access_token_secret = Twikeys::Access_token_secret
    end

    client_jp = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'twitter_jp')
		@collection_jp = client_jp[:twitter_jp]

    client_nojp = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'twitter_nojp')
		@collection_nojp = client_nojp[:twitter_nojp]

  end


  def start
    @client.sample do |status|
			if status.is_a?(Twitter::Tweet) then
      	if status.lang == "ja" || status.user.lang == "ja" then
        	@collection_jp.insert_one(status.to_h)
      	else
        	@collection_nojp.insert_one(status.to_h)
      	end

				@count += 1
				print(@count.to_s + "\n") if @count % 100 == 0
    	end
		end
  end



end


collector = Tweet_Collector.new()
collector.start

print("now collecting" + "\n")
gets
exit(0)
