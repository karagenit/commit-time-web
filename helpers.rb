#!/usr/bin/env ruby

require 'sinatra'

helpers do
  def time_fmt(minutes)
    "#{(minutes / 60).floor} Hours, #{(minutes % 60).round} Minutes"
  end
end
