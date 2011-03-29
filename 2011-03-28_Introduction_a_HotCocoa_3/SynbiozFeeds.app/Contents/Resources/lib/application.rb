require 'rubygems'
require 'hotcocoa'
require 'feedparser'
require 'open-uri'

class Application

  include HotCocoa
  
  def start
    application :name => "SynbiozFeeds" do |app|
      app.delegate = self
      window(:size => [640, 480], :center => true, :title => "Synbioz Feed", :view => :nolayout) do |win|
        win.will_close { exit }

        win.view = layout_view(:layout => {:expand => [:width, :height], :padding => 0, :margin => 0}) do |vert|
          vert << layout_view(:frame => [0, 0, 0, 40], :mode => :horizontal, :layout => {:padding => 0, :margin => 0, :start => false, :expand => [:width]}) do |horiz|
            horiz << label(:text => "Flux RSS", :layout => {:align => :center})
            horiz << @feed_field = text_field(:layout => {:expand => [:width]})
            horiz << button(:title => 'lire', :layout => {:align => :center}) do |b|
              b.on_action { load_feed }
            end
          end

          vert << scroll_view(:layout => {:expand => [:width, :height]}) do |scroll|
            scroll.setAutohidesScrollers(true)
            scroll << @table = table_view(:columns => [column(:id => :data, :title => '')], :data => []) do |table|
               table.setUsesAlternatingRowBackgroundColors(true)
               table.setGridStyleMask(NSTableViewSolidHorizontalGridLineMask)
               #table.setDelegate(self)
               table.on_action do
                 url = NSURL.URLWithString(table.dataSource.data[table.clickedRow][:link])
                 NSWorkspace.sharedWorkspace.openURL(url)
               end
            end
          end
        end
      end
    end
  end
  
  def load_feed
    url = @feed_field.stringValue
    unless url.nil? || url =~ /^\s*$/
      feed = FeedParser::Feed.new open(url).read
      latest_posts = feed.items[0..9]
      
      latest_posts.each do |p|
        @table.dataSource.data << {:data => "#{p.title} par #{p.creators.join(', ')}", :link => p.link}
      end
      @table.reloadData
    end
  end
end

Application.new.start