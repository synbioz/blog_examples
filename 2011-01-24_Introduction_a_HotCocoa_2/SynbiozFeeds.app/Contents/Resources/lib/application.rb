require 'rubygems'
require 'hotcocoa'

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
            scroll << @table = table_view(:columns => [column(:id => :data, :title => '')],
                                          :data => []) do |table|
               table.setUsesAlternatingRowBackgroundColors(true)
               table.setGridStyleMask(NSTableViewSolidHorizontalGridLineMask)                             
            end
          end
        end
      end
    end
  end
  
  def load_feed
    str = @feed_field.stringValue
    unless str.nil? || str =~ /^\s*$/
      10.times do |i|
        title = str + " - article #{i.next}"
        @table.dataSource.data << {:data => title}
      end
      @table.reloadData
    end
  end
end

Application.new.start