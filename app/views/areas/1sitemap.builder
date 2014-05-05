xml.instruct! # for the <?xml version="1.0" encoding="UTF-8"?> line
xml.urlset(xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9") do
  @areas.each do |area|
    @pages.each do |page|
      xml.url do
        xml.loc 'http://kupilegal.ru/' + area.slug + '/' + page.slug
        xml.priority '1'
      end
    end
  end
end