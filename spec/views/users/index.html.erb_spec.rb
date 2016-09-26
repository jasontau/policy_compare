require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :name => "Name",
        :email => "Email",
        :title => "Title",
        :company => "Company",
        :phone => "Phone",
        :password => "Password",
        :password_confirmation => "Password Confirmation",
        :admin => false
      ),
      User.create!(
        :name => "Name",
        :email => "Email",
        :title => "Title",
        :company => "Company",
        :phone => "Phone",
        :password => "Password",
        :password_confirmation => "Password Confirmation",
        :admin => false
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Company".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Password".to_s, :count => 2
    assert_select "tr>td", :text => "Password Confirmation".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
