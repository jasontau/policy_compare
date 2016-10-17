require 'rails_helper'

RSpec.describe "accounts/index", type: :view do
  before(:each) do
    assign(:accounts, [
      Account.create!(
        :description => "MyText",
        :customer => nil,
        :sic => nil,
        :status => nil
      ),
      Account.create!(
        :description => "MyText",
        :customer => nil,
        :sic => nil,
        :status => nil
      )
    ])
  end

  it "renders a list of accounts" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
