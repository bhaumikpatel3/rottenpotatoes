module MoviesHelper
  SORT_LABELS = { "title" => "Title", "rating" => "Rating", "release_date" => "Release date" }.freeze

  def sorted_column_class(column)
    "sorted-column sort-#{@direction}" if @sort == column
  end

  def column_sort_state(column)
    return "none" unless @sort == column

    @direction == "asc" ? "ascending" : "descending"
  end

  def sort_link(column)
    next_direction = @sort == column && @direction == "asc" ? "desc" : "asc"
    label = SORT_LABELS.fetch(column)
    next_label = next_direction == "asc" ? "ascending" : "descending"
    symbol = @sort == column ? (@direction == "asc" ? "▲" : "▼") : "↕"

    link_to movies_path(sort: column, direction: next_direction),
      aria: { label: "#{label}: sort #{next_label}" } do
      safe_join([ label, tag.span(symbol, class: "sort-symbol", aria: { hidden: true }) ], " ")
    end
  end
end
