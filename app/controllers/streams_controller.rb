class StreamsController < ApplicationController
  require 'rss'
  
  def photos

  end

  def index
     begin
       @latest_blog_posts = RSS::Parser.parse(open('http://blog.streams.tw/rss').read, false).items[0…5]
     rescue
       # Do nothing, just continue.  The view will skip the blog section if the feed is nil.
       @latest_blog_posts = nil
     end
  end

end
