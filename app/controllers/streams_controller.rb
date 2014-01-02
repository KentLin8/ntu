class StreamsController < ApplicationController
  require 'rss'
  
  def photos
    require 'rubygems'
    require 'google_drive'

    if  $my_photos_list.nil?
      # Logs in.# You can also use OAuth. See document of GoogleDrive.login_with_oauth for details.
      google_session =  GoogleDrive.login('streams.in.taipei@gmail.com', Ntu::Application::Google_Driver_Login_P)
      # First worksheet of https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
      $my_photos_list =  google_session.spreadsheet_by_key('0AjhbVFj0RYrOdGw4c3Nvb2pDT2h0ODFPRGFjcDRTM2c').worksheets[0]
    end


  end

  def index
     begin
       @latest_blog_posts = RSS::Parser.parse(open('http://blog.streams.tw/rss').read, false).items[0..3]
     rescue
       # Do nothing, just continue.  The view will skip the blog section if the feed is nil.
       @latest_blog_posts = nil
     end
  end

  def stores

  end

  def about

  end

  def what_we_do

  end

  def menu

  end

end
