require 'spec_helper'


describe Api::PagesController do
  render_views
  context 'collections' do
    before(:each) do
      # Create 2 published page
      @published_titles = ["published title 1", "published title 2"]
      @published_titles.each do |title|
        FactoryGirl.create(:page, :title => title, :published_on => 1.days.ago)
      end
      # Create 1 unpublished page
      @unpublished_title = "unpublished title"
      FactoryGirl.create(:page, :title => @unpublished_title, :published_on => 1.days.from_now)
    end


    it "gets all pages" do
      api_get :index
      json_response.length.should eq(3)
    end

    it "get all published pages" do
      api_get :published
      json_response.length.should eq(2)
      json_response.each do |page|
        @published_titles.should be_include(page['page']['title'])
      end
    end

    it "get all unpublished pages" do
      api_get :unpublished
      json_response.length.should eq(1)
      json_response.first['page']['title'].should eql(@unpublished_title)
    end

  end

  context "member" do
    before(:each) do
      @page = FactoryGirl.create(:page)
    end

    it "show page" do
      api_get :show, :id => @page.id
      title = json_response['page']['title']
      title.should eq @page.title
    end

    it "create page success" do
      lambda do
        api_post :create, :page =>
            {:title => Faker::Lorem.sentence, :content => Faker::Lorem.paragraphs}
      end.should change(Page, :count).by(1)
    end

    it "update success" do
      api_put :update, :id => @page.id, :page => {:title => "updated title"}
      json_response['page']['title'].should eq 'updated title'
    end

    it "create unsuccessful" do
      lambda do
        api_post :create, :page =>
            {:title => '', :content => Faker::Lorem.paragraphs}
        json_response["errors"]["title"].should_not be_blank
      end.should_not change(Page, :count).by(1)
    end

    it "publish " do
      @page.published_on = 2.day.from_now
      @page.save

      api_put :publish, :id => @page.id

      @page.reload
      @page.should be_published
    end

    it 'total words' do
      @page = FactoryGirl.create(:page, :content => '123 Test Lane')
      api_get :total_words, :id => @page.id
      json_response['page']['total_word'].should eq(3)
    end

  end


end

