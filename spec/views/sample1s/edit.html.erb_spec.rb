require 'spec_helper'

describe "sample1s/edit" do
  before(:each) do
    @sample1 = assign(:sample1, stub_model(Sample1,
      :hoge => "MyString"
    ))
  end

  it "renders the edit sample1 form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sample1s_path(@sample1), :method => "post" do
      assert_select "input#sample1_hoge", :name => "sample1[hoge]"
    end
  end
end
