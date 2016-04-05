require 'test_helper'

class SocialIdTest < ActiveSupport::TestCase
  def setup
    @company_for_first_id = Company.new(name: "test1")
    @company_for_second_id = Company.new(name: "test2")
    @id = social_ids(:one)
    @id.company = @company_for_first_id
    @new_id = SocialId.new(company: @company_for_second_id)
  end

  test "should be valid" do
    assert @id.valid?
  end

  test "new id should be valid" do
    assert @new_id.valid?
  end

  test "should not be valid" do
    @new_id.company = nil
    assert_not @new_id.valid?
  end

  test "two ids should have different companies" do
    @test_id = SocialId.new(company: @company_for_second_id)
    @new_id.save
    assert_not @test_id.valid?
  end
end
