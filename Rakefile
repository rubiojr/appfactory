# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/appfactory.rb'

Choice.options do
  banner 'Usage: appfactory <app_name>'
  header ''
  header 'Available options:'

  option :help do
    long '--help'
    short '-h'
    desc 'Show this message'
    action do 
      Choice.help
      exit
    end
  end
end

Hoe.new('appfactory', AppFactory::VERSION) do |p|
  p.developer('Sergio Rubio', 'sergio@rubio.name')
  p.summary = 'Mac OS X StatusBar App Builder!'
  p.description = 'Easily create Status Bar Applications for Mac OS X'
  p.url = 'http://github.com/rubiojr/appfactory'
  p.extra_deps << [ 'choice' ]
end

# vim: syntax=Ruby
