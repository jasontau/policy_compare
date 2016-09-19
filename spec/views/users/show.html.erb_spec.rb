require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :name => "Name",
      :email => "Email",
      :title => "Title",
      :company => "Company",
      :phone => "Phone",
      :password => "Password",
      :password_confirmation => "Password Confirmation",
      :admin => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Company/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Password/)
    expect(rendered).to match(/Password Confirmation/)
    expect(rendered).to match(/false/)
  end
end
