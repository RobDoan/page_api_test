module Api::PagesHelper
  def total_word(text)
    return 0 unless text
    strip_tags(text).scan(/(\w|-)+/).size
  end
end
