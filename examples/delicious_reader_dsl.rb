require 'open-uri'
require 'restclient'
require 'json'

register_growl_events [:updating_feeds]

menu 'delicious.com' do |m|
end

menu_separator

menu_quit

timer 10 do
  AppFactory.debug 'running feed parser'
  growl :updating_feeds, 'Delicious Reader', 'Updating latest feeds from delicious.com'
  json_feed = JSON.parse(RestClient.get "http://feeds.delicious.com/v2/json/")
  menu 'delicious.com' do |m|
    clear_menu m
    json_feed.each do |i|
      AppFactory.debug "Adding item: #{i['d']}"
      menu_item i['d'] do
        open_url i['u']
      end
    end
  end
end
