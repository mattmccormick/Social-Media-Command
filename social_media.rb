#!/usr/bin/env ruby
require 'twitter'
require 'json'
require 'optparse'
require '~/.social_media.rb'

options = {}

OptionParser.new do |opts|
	opts.banner = "Usage: social_media.rb [options] message"

	opts.on('-a', 'Post to all') do |a|
		options[:all] = a
	end

	opts.on("-f", "Post to Facebook") do |f|
		options[:facebook] = f
	end

	opts.on('-g', 'Post to Google+') do |g|
		options[:google_plus] = g
	end
	
	opts.on('-l', 'Post to LinkedIn') do |l|
		options[:linked_in] = l
	end

	opts.on("-t", "Post to Twitter") do |t|
		options[:twitter] = t
	end
end.parse!

def facebook(message)
	puts 'Posting to Facebook'
	out = `curl -F 'access_token=#{FACEBOOK_ACCESS_TOKEN}' -F 'message=#{message}' https://graph.facebook.com/me/feed`
	j = JSON.parse(out)
	if !j.has_key?('id')
		p out
	else
		puts 'Successfully posted'
	end
end

def google_plus(message)
	puts 'Posting to Google+'
end

def linked_in(message)
	puts 'Posting to LinkedIn'
end

def twitter(message)
	puts 'Posting to Twitter'
	status = Twitter.update(message)
	puts status.attrs.has_key?('id') ? 'Successfully posted' : p status
end

message = ARGV[0]

if message.nil?
	puts 'Please enter a message'
	exit
elsif message.length > 140 && options.has_key?(:twitter)
	puts 'Cannot post message as message is being posted to Twitter and is longer than 140 characters'
	exit
end

if options.has_key?(:all)
	facebook(message)
	google_plus(message)
	linked_in(message)
	twitter(message)
else
	[:facebook, :google_plus, :linked_in, :twitter].each do |s|
		if options.has_key?(s)
			send(s, message)	
		end
	end
end

