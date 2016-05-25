require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['TWITTER_API_KEY']
  config.consumer_secret     = ENV['TWITTER_API_SECRET']
  # config.access_token        = ENV['TWITTER_ACCESS_TOKEN_SECRET']
  # config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN']
end


def collect_with_max_id(collection=[], max_id=nil, &block)
  response = yield(max_id)
  collection += response
  response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
end

def client.get_all_tweets(user)

  collect_with_max_id do |max_id|
    options = {:count => 200, :include_rts => false}
    options[:max_id] = max_id unless max_id.nil?
    user_timeline(user, options)
  end
end

client.user('yalestar')
# puts client.bearer_token
vv  = client.get_all_tweets('Slate')
re = /stop|quit|don\'t/i
vv.uniq.each do |t|
	puts t.text if re.match(t.text)
end
# options = {:count => 200, :include_rts => true}
# client.user_timeline("yalestar", options)