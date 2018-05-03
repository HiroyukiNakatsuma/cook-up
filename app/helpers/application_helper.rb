module ApplicationHelper

  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    base_title = "Cook-up"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def redirect_root_with_success_message(message)
    flash[:success] = message
    redirect_to root_path
  end
end
