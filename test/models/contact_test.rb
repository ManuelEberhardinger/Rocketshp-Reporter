require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  def setup
    @company = Company.new(name: 'Example Company')
    @contact = Contact.new(company: @company, first_name: "Example User")
  end

  test "should be valid" do
    assert @contact.valid?
  end

  test "name should be present" do
    @contact.first_name = ""
    assert_not @contact.valid?
  end

  test "company should be present" do
    @contact.company = nil
    assert_not @contact.valid?
  end
end
