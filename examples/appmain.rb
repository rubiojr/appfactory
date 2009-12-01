require 'open-uri'
require 'restclient'
require 'json'

menu_item :Hello do 
  growl :say_hello, 'FooApp', 'Hello!!'
end 

menu_item :Goodbye do 
  growl :say_goodbye, 'FooApp', 'Good bye!!'
end 

menu :Feeds do |m|
end

register_growl_events [:say_hello, :say_goodbye]

timer 5 do
  AppFactory.debug 'running feed parser'
  json_feed = JSON.parse(RestClient.get "http://feeds.delicious.com/v2/json/")

  json_feed.each do |i|
    AppFactory.debug "Adding item: #{i['d']}"
    menu :Feeds do
      menu_item i['d'] do
      end
    end
  end
end
