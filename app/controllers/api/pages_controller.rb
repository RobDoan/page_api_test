class Api::PagesController < ApiController
  before_filter :load_page,
                :except => [:index, :published, :unpublished]


  def index
    @pages = Page.all
  end

  def published
    @pages = Page.published
    render :index
  end

  def unpublished
    @pages = Page.unpublished
    render :index
  end

  def total_words

  end

  def publish
    @page.publish!
    render :show
  end

  def create
    if @page.save
      render :show, :status => 201
    else
      invalid_resource!(@page)
    end
  end

  def update
    if @page.update_attributes(params[:page])
      render :show
    else
      invalid_resource!(@page)
    end
  end

  def destroy
    @page.destroy
    render :text => nil, :status => 200
  end


  protected

  def load_page
    if params[:id]
      @page = Page.find(params[:id])
    else
      @page = Page.new(params[:page])
    end
  end


end
