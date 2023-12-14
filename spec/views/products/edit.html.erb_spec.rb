require 'rails_helper'

RSpec.describe "products/edit", type: :view do
  let(:product) {
    Product.create!(
      code: "MyString",
      name: "MyString",
      price: "9.99"
    )
  }

  before(:each) do
    assign(:product, product)
  end

  it "renders the edit product form" do
    render

    assert_select "form[action=?][method=?]", product_path(product), "post" do

      assert_select "input[name=?]", "product[code]"

      assert_select "input[name=?]", "product[name]"

      assert_select "input[name=?]", "product[price]"
    end
  end
end
