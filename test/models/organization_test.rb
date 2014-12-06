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

require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
