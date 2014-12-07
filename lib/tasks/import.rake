require 'csv'
require 'open-uri'

namespace :import do
  desc 'imports the startup genome csv into database'
  task startup_genome: :environment do
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
  task angel_list: :environment do
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

  desc 'fetches and imports data from investors.csv'
  task investors: :environment do
    file = File.open(Rails.root.join('lib', 'tasks', 'investors.csv'))
    CSV.foreach(file.path, headers: true) do |row|
      o = Organization.new(
        name: row[0].squish,
        website: row[1].squish,
        description: row[2].squish[0..200],
        address: row[4].squish,
        approved: true,
        category_id: 2,
        logo_url: row[3]
      )
      o.save
    end
  end

  desc 'fetches and imports data from accelerators.csv'
  task accelerators: :environment do
    file = File.open(Rails.root.join('lib', 'tasks', 'accelerators.csv'))
    CSV.foreach(file.path, headers: true) do |row|
      o = Organization.new(
        name: row[0].squish,
        website: row[1].squish,
        description: row[2].squish[0..200],
        address: row[4].squish,
        approved: true,
        category_id: 3,
        logo_url: row[3]
      )
      o.save
    end
  end

  desc 'fetches and imports data from coworking_spaces.csv'
  task coworking_spaces: :environment do
    file = File.open(Rails.root.join('lib', 'tasks', 'coworking_spaces.csv'))
    CSV.foreach(file.path, headers: true) do |row|
      o = Organization.new(
        name: row[0].squish,
        website: row[1].squish,
        description: row[2].squish[0..200],
        address: row[4].squish,
        approved: true,
        category_id: 5,
        logo_url: row[3]
      )
      o.save
    end
  end

  desc 'fetches and imports data from incubators.csv'
  task incubators: :environment do
    file = File.open(Rails.root.join('lib', 'tasks', 'incubators.csv'))
    CSV.foreach(file.path, headers: true) do |row|
      o = Organization.new(
        name: row[0].squish,
        website: row[1].squish,
        description: row[2].squish[0..200],
        address: row[4].squish,
        approved: true,
        category_id: 4,
        logo_url: row[3]
      )
      o.save
    end
  end
end