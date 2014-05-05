require 'csv'

task parse_csv: :environment do
  CSV.foreach('keys.csv', headers: true) do |row|
    page = Page.new
    page.title = row[0]
    page.save!
  end
end
