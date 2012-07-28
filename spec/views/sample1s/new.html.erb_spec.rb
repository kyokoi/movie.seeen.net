require 'spec_helper'

describe "sample1s/new" do
  before(:each) do
    assign(:sample1, stub_model(Sample1,
      :hoge => "MyString"
    ).as_new_record)
  end

  it "renders new sample1 form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sample1s_path, :method => "post" do
      assert_select "input#sample1_hoge", :name => "sample1[hoge]"
    end
  end
end
