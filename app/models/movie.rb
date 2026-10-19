class Movie < ActiveRecord::Base
  SORTABLE_COLUMNS = %w[title rating release_date].freeze

  def self.sorted_by(column, direction)
    return all unless SORTABLE_COLUMNS.include?(column)
    order(column => (direction == "desc" ? :desc : :asc))
  end
end
