require 'spec_helper'

describe "sample1s/index" do
  before(:each) do
    assign(:sample1s, [
      stub_model(Sample1,
        :hoge => "Hoge"
      ),
      stub_model(Sample1,
        :hoge => "Hoge"
      )
    ])
  end

  it "renders a list of sample1s" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Hoge".to_s, :count => 2
  end
end
