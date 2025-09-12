module ApplicationHelper
  
  # タイトル表示のメソッド
  def page_title(title = '')
  base_title = 'To-Sile APP'
  title.present? ? "#{title} | #{base_title}" : base_title
  end
end
