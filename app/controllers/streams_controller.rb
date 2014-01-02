class StreamsController < ApplicationController
  require 'rss'
  
  def photos
    require 'rubygems'
    #require 'google_drive'

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

    if  $my_menu_list.nil?
      # Logs in.# You can also use OAuth. See document of GoogleDrive.login_with_oauth for details.
      google_session =  GoogleDrive.login('streams.in.taipei@gmail.com', Ntu::Application::Google_Driver_Login_P)
      # First worksheet of https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
      $my_menu_list =  google_session.spreadsheet_by_key('0Aj3HE-dOCGJVdHdQWGpja292LWNINmwyWkNHbEp3THc').worksheets[0]
    end

    @packages = []
    for row in 2..$my_menu_list.num_rows
      @packages << {name: $my_Menu_list[row,1], dishes: []} unless $my_Menu_list[row,1].blank?
      @packages.last[:dishes] << {name: $my_Menu_list[row,2], introduction: $my_Menu_list[row,3], link: $my_Menu_list[row,4]}
    end

  end

  require 'google/api_client'
# download file
  def download(file_id)
    # Get your credentials from the APIs Console


# Create a new API client & load the Google Drive API
    @client = Google::APIClient.new
    @drive = @client.discovered_api('drive', 'v2')

# Request authorization
    @client.authorization.client_id = '637482934469-jgn3jfs8ve8thomkeor69asfbp0vqg0s.apps.googleusercontent.com'
    @client.authorization.client_secret = 'ADt-8uGe-drNIGJtMOOzH4fE'
    @client.authorization.scope = 'https://www.googleapis.com/auth/drive'
    @client.authorization.redirect_uri = 'urn:ietf:wg:oauth:2.0:oob'

# Exchange authorization code for access token
    @client.authorization.refresh_token = '1/2jVXqxXg6op87Z7friatr3sjNCLlwIH1FfLSMeRt55I'
    @client.authorization.fetch_access_token!

    download_url = "https://docs.google.com/feeds/download/spreadsheets/Export?key=#{file_id}&exportFormat=tsv&gid=0"
    result = @client.execute(:uri => download_url)
    if result.success?
      result.body.force_encoding 'UTF-8'
    else
      Log.error('download fail...')
      nil
    end
  end

end
