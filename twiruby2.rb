#!/usr/bin/ruby

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

    connection = Mongo::Connection.new
    db = connection.db('twitter_jp')
    @jp_col = db.collection('twitter_jp')

    db = connection.db('twitter_nojp')
    @nojp_col = db.collection('twitter_nojp')
  end


  def start
    @client.sample do |status|
      if status.lang == "ja" || status.user.lang == "ja" then
        @jp_col.insert(status.to_h)
      else
        @nojp_col.insert(status.to_h)
      end

			@count += 1
			print(@count.to_s + "\n") if @count % 100 == 0
    end
  end



end


collector = Tweet_Collector.new()
collector.start

print("now collecting" + "\n")
gets
exit(0)
