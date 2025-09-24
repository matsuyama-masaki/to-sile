module ApplicationHelper
  
  # タイトル表示のメソッド
  def page_title(title = '')
  # タイトルが空でなければ、「タイトル | To-Sile APP」と表示し、空なら「To-Sile APP」と表示する
  base_title = 'To-Sile APP'
  title.present? ? "#{title} | #{base_title}" : base_title
  end
end
