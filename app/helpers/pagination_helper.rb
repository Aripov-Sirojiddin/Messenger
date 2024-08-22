module PaginationHelper
  def can_go_to_next_page?(array, page, per_page)
    page += 1
    page <= (array.count/per_page) && array.each_slice(per_page).to_a[page].count > 0
  end
  def total_pages(array, per_page)
    array.each_slice(per_page).to_a.count
  end
  def can_go_to_previous_page?(array, page, per_page)
    page -= 1
    page >= 0 && array.each_slice(per_page).to_a[page].count > 0
  end
end