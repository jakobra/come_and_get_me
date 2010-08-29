task :site_map => :environment do
  sitemap = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">"
  
  MenuNode.find(:all, :conditions => {:viewable => true}).each do |node|
    sitemap += "\n\t<url>\n\t\t<loc>http://www.comeandgetme.se#{node.url}</loc>\n\t</url>"
  end
  
  sitemap += "\n\t<url>\n\t\t<loc>http://www.comeandgetme.se/info/om</loc>\n\t</url>"
  sitemap += "\n\t<url>\n\t\t<loc>http://www.comeandgetme.se/info/kontakt</loc>\n\t</url>"
  sitemap += "\n\t<url>\n\t\t<loc>http://www.comeandgetme.se/info/villkor</loc>\n\t</url>"

  User.find(:all).each do |user|
    sitemap += "\n\t<url>\n\t\t<loc>http://www.comeandgetme.se/#{user.login}</loc>\n\t</url>"
  end
  
  Track.all.each do |track|
    sitemap += "\n\t<url>\n\t\t<loc>http://www.comeandgetme.se/tracks/#{track.to_param}</loc>\n\t</url>"
    sitemap += "\n\t<url>\n\t\t<loc>http://www.comeandgetme.se/tracks/#{track.to_param}/records</loc>\n\t</url>"
  end
  
  sitemap += "\n</urlset>"
  
  puts sitemap
  
  File.open(RAILS_ROOT + "/public/sitemap.xml", 'w') {|f| f.write(sitemap) }
end