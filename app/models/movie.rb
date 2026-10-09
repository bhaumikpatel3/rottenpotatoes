class Movie < ApplicationRecord
  RATINGS = %w[G PG PG-13 R NC-17].freeze
  SORT_COLUMNS = %w[title rating release_date].freeze
  SORT_DIRECTIONS = %w[asc desc].freeze

  normalizes :title, with: ->(title) { title.strip }

  validates :title, presence: true
  validates :rating, inclusion: { in: RATINGS }
  validates :release_date, presence: true

  # Sort in the database. Never pass an unchecked request parameter to SQL.
  def self.sorted(column, direction)
    column = "title" unless SORT_COLUMNS.include?(column)
    direction = "asc" unless SORT_DIRECTIONS.include?(direction)
    order(column => direction, :id => :asc)
  end
end
