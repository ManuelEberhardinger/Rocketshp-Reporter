require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  def setup
    @company = Company.new(name: "Example Company")
  end

  test "should be valid" do
    assert @company.valid?
  end

  test "name should be present" do
    @company.name = ""
    assert_not @company.valid?
  end

  test "name should be unique" do
    @company_test = @company.dup
    @company.save
    assert_not @company_test.valid?
  end
end
