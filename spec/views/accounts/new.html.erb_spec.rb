require 'rails_helper'

RSpec.describe "accounts/new", type: :view do
  before(:each) do
    assign(:account, Account.new(
      :description => "MyText",
      :customer => nil,
      :sic => nil,
      :status => nil
    ))
  end

  it "renders new account form" do
    render

    assert_select "form[action=?][method=?]", accounts_path, "post" do

      assert_select "textarea#account_description[name=?]", "account[description]"

      assert_select "input#account_customer_id[name=?]", "account[customer_id]"

      assert_select "input#account_sic_id[name=?]", "account[sic_id]"

      assert_select "input#account_status_id[name=?]", "account[status_id]"
    end
  end
end
