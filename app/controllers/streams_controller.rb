class StreamsController < ApplicationController
  layout "photos", :only => :photos
  require 'rss'
  
  def photos

    if  $my_photos_list.nil?
        reload_photo
    end

    @page_title = '荒漠甘泉餐廳-Photos'

    @page_header =  ''

  end

  def index
    if  $my_about_list.nil?
      reload_about
    end

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

  def reload_menu
    # Logs in.# You can also use OAuth. See document of GoogleDrive.login_with_oauth for details.
    google_session =  GoogleDrive.login('streams.in.taipei@gmail.com', Ntu::Application::Google_Driver_Login_P)
    # First worksheet of https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
    $my_menu_list =  google_session.spreadsheet_by_key('0Aj3HE-dOCGJVdHdQWGpja292LWNINmwyWkNHbEp3THc').worksheets[0]
  end

  def reload_photo
    require 'rubygems'
    #require 'google_drive'
    # Logs in.# You can also use OAuth. See document of GoogleDrive.login_with_oauth for details.
    google_session =  GoogleDrive.login('streams.in.taipei@gmail.com', Ntu::Application::Google_Driver_Login_P)
    # First worksheet of https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
    $my_photos_list =  google_session.spreadsheet_by_key('0AjhbVFj0RYrOdGw4c3Nvb2pDT2h0ODFPRGFjcDRTM2c').worksheets[0]

  end

  def reload_about
    require 'rubygems'
    #require 'google_drive'
    # Logs in.# You can also use OAuth. See document of GoogleDrive.login_with_oauth for details.
    google_session =  GoogleDrive.login('streams.in.taipei@gmail.com', Ntu::Application::Google_Driver_Login_P)
    # First worksheet of https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
    $my_about_list =  google_session.spreadsheet_by_key('0AjhbVFj0RYrOdDQ2R3hlbDItZkJzTy1kRjJEdFVzYXc').worksheets[0]

  end



  def menu

    if  $my_menu_list.nil?
      reload_menu
    end

    @packages = []
    for row in 2..$my_menu_list.num_rows
      @packages << {name: $my_menu_list[row,1], dishes: []} unless $my_menu_list[row,1].blank?
      @packages.last[:dishes] << {name: $my_menu_list[row,2], introduction: $my_menu_list[row,3], link: $my_menu_list[row,4]}
    end

  end

end
