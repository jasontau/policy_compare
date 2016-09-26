require 'rails_helper'

RSpec.describe "users/new", type: :view do
  before(:each) do
    assign(:user, User.new(
      :name => "MyString",
      :email => "MyString",
      :title => "MyString",
      :company => "MyString",
      :phone => "MyString",
      :password => "MyString",
      :password_confirmation => "MyString",
      :admin => false
    ))
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", users_path, "post" do

      assert_select "input#user_name[name=?]", "user[name]"

      assert_select "input#user_email[name=?]", "user[email]"

      assert_select "input#user_title[name=?]", "user[title]"

      assert_select "input#user_company[name=?]", "user[company]"

      assert_select "input#user_phone[name=?]", "user[phone]"

      assert_select "input#user_password[name=?]", "user[password]"

      assert_select "input#user_password_confirmation[name=?]", "user[password_confirmation]"

      assert_select "input#user_admin[name=?]", "user[admin]"
    end
  end
end
