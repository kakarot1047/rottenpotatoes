class Movie < ActiveRecord::Base
  SORTABLE_COLUMNS = %w[title rating director release_date stars].freeze

  validates :stars,
            numericality: { only_integer: true, in: 1..5 },
            allow_nil: true

  def self.sorted_by(column, direction)
    return all unless SORTABLE_COLUMNS.include?(column)

    order(column => (direction == "desc" ? :desc : :asc))
  end
end
