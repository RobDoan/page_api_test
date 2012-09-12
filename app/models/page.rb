class Page < ActiveRecord::Base
  attr_accessible :title, :content, :published_on

  validates :title, :content, :presence => true

  before_validation :strip_title

  scope :published, where("published_on <= ? ", Time.now)
  scope :unpublished, where("published_on is NULL OR published_on > ?  ", Time.now)

  def published?
    self.published_on && self.published_on <= Time.now
  end

  def publish!
    self.published_on = Time.now
    self.save!
  end

  protected
  def strip_title
    self.title = self.title.strip if self.title
  end

end
