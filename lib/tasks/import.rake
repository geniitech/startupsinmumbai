require 'csv'
require 'open-uri'

desc 'imports the startup genome csv into database'
task import: :environment do
  file = File.open(Rails.root.join('lib', 'tasks', 'startup_genome_mumbai.csv'))
  CSV.foreach(file.path, headers: true) do |row|
    o = Organization.new(
      name: row[0],
      description: row[1][0..240],
      founded_in: row[2],
      address: row[3],
      approved: false
    )
    if row[5] == "Venture Capital"
      o.category_id = 2
    elsif row[5] == "Startups"
      o.category_id = 1
    end
    o.logo_from_url = row[6]
    o.tag_list = row[4].downcase
    o.save!
  end
end

desc 'fetches and imports data from angelist'
task import_angel_list: :environment do
  [1..21].each do |index|
    json_result = JSON.load(open("https://api.angel.co/1/tags/22939/startups?page=#{index}"))
    json_result["startups"].each do |startup|
      unless startup["hidden"] == true
        o = Organization.new(
          name: startup["name"],
          description: startup["high_concept"],
          address: 'N/A',
          website: startup["company_url"],
          approved: false
        )
        o.category_id = 1
        o.logo_from_url = startup["logo_url"]
        o.tag_list = startup["company_type"].collect{|c| c["name"]}.join(", ").downcase rescue nil
        o.save!
      end
    end
  end
end