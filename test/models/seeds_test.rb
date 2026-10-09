require "test_helper"

class SeedsTest < ActiveSupport::TestCase
  test "eight movies are seeded and repeated seeds preserve records and edits" do
    load Rails.root.join("db/seeds.rb")
    assert_equal 8, Movie.count
    original_ids = Movie.order(:id).pluck(:id)
    assert Movie.exists?(title: "Spirited Away")
    assert Movie.exists?(title: "The Incredibles")
    assert Movie.exists?(title: "The Grand Budapest Hotel")

    movie = Movie.find_by!(title: "CODA")
    movie.update!(description: "A personal note.")
    load Rails.root.join("db/seeds.rb")
    assert_equal original_ids, Movie.order(:id).pluck(:id)
    assert_equal "A personal note.", movie.reload.description
  end
end
