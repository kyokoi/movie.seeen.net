require 'spec_helper'

describe "sample1s/show" do
  before(:each) do
    @sample1 = assign(:sample1, stub_model(Sample1,
      :hoge => "Hoge"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Hoge/)
  end
end
