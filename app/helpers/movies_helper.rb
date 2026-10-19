module MoviesHelper
  def sort_class(column)
    "sorted-#{@sort_direction}" if column == @sort_column
  end

  def sort_header(label, column)
    active    = column == @sort_column
    next_dir  = active && @sort_direction == "asc" ? "desc" : "asc"
    indicator = active ? (@sort_direction == "asc" ? " ▲" : " ▼") : ""
    aria_sort = active ? (@sort_direction == "asc" ? "ascending" : "descending") : "none"

    tag.th(scope: "col", aria: { sort: aria_sort }) do
      link_to "#{label}#{indicator}", movies_path(sort: column, direction: next_dir)
    end
  end
end
