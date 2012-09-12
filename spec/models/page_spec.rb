require 'spec_helper'

describe Page do
  context "validation" do
    [:title, :content].each do |attr|
      it "#{attr} should be be blank" do

        page = FactoryGirl.build(:page, attr => nil)
        page.should_not be_valid
        lambda {
          page.save
        }.should_not change(Page, :count).by(1)
      end
    end
  end

  it 'title should strip before validation' do
    title_with_space = " title with space on left and right "
    page = FactoryGirl.create(:page, :title => title_with_space)
    page.valid?
    page.title.should eql(title_with_space.strip)
  end

  it 'published?' do
    page = FactoryGirl.create(:page)
    page.published_on = nil
    page.should_not be_published
    page.published_on = 10.hours.from_now
    page.should_not be_published
    page.published_on = 1.minutes.ago
    page.should be_published
  end

  context "scope" do
    before(:each) do
      # Create 2 published page
      2.times do
        FactoryGirl.create(:page, :published_on => 1.days.ago)
      end
      # Create 1 unpublished page
      FactoryGirl.create(:page, :published_on => 1.days.from_now)
    end

    it "unpublished" do
      Page.unpublished.count.should eq(1)
    end

    it "published" do
      Page.published.count.should eq(2)
    end
  end
end
