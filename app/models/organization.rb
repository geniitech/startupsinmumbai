# == Schema Information
#
# Table name: organizations
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  website           :string(255)
#  description       :string(255)
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#  address           :string(255)
#  latitude          :float(24)
#  longitude         :float(24)
#  founded_in        :integer
#  approved          :boolean
#  submitter_email   :string(255)
#  submitter_name    :string(255)
#  category_id       :integer
#  created_at        :datetime
#  updated_at        :datetime
#
require 'open-uri'

class Organization < ActiveRecord::Base
  belongs_to :category
  acts_as_taggable

  validates :name, :address, presence: true
  validates :approved, inclusion: { in: [true, false] }
  validates :submitter_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, allow_blank: true

  has_attached_file :logo, styles: { thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment :logo, content_type: { content_type: /\Aimage\/.*\Z/ }, size: { in: 0..1.megabytes }

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  def logo_url=(url)
    self.logo = URI.parse(URI.encode(url)) rescue nil
  end
end
