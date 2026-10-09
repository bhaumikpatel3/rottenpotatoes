require "test_helper"

class MoviesTest < ActionDispatch::IntegrationTest
  setup do
    @aster = Movie.create!(title: "Aster", rating: "R", release_date: "2020-05-01", description: "A hidden garden story.")
    @birch = Movie.create!(title: "Birch", rating: "G", release_date: "2024-01-01")
    @cedar = Movie.create!(title: "Cedar", rating: "PG", release_date: "1999-09-01")
  end

  test "root leads to a semantic movie table without descriptions" do
    get root_path
    assert_redirected_to movies_path
    follow_redirect!
    assert_response :success
    assert_select "table#movies thead th[scope=col]", count: 4
    assert_select "table#movies tbody tr", count: 3
    assert_select "table#movies tfoot", text: /3 movies/
    assert_select "link[rel=stylesheet]"
    assert_select "body", text: /A hidden garden story/, count: 0
    assert_equal %w[Aster Birch Cedar], titles_on_page
  end

  {
    "title" => %w[Aster Birch Cedar],
    "rating" => %w[Birch Cedar Aster],
    "release_date" => %w[Cedar Aster Birch]
  }.each do |column, ascending|
    %w[asc desc].each do |direction|
      test "sort #{column} #{direction} with accessible highlight and reverse link" do
        get movies_path, params: { sort: column, direction: direction }
        assert_response :success
        assert_equal direction == "asc" ? ascending : ascending.reverse, titles_on_page
        state = direction == "asc" ? "ascending" : "descending"
        symbol = direction == "asc" ? "▲" : "▼"
        reverse = direction == "asc" ? "desc" : "asc"
        assert_select "th.sorted-column.sort-#{direction}[aria-sort=#{state}]", count: 1 do
          assert_select ".sort-symbol", text: symbol
          assert_select "a[href=?]", movies_path(sort: column, direction: reverse)
        end
        assert_select "tbody td.sorted-column.sort-#{direction}", count: 3
      end
    end
  end

  test "create read update and delete a movie" do
    get new_movie_path
    assert_response :success
    assert_select "form input[name='movie[title]']"

    assert_difference "Movie.count", 1 do
      post movies_path, params: { movie: { title: "New Story", rating: "PG", release_date: "2005-06-07", description: "An original story." } }
    end
    movie = Movie.find_by!(title: "New Story")
    assert_redirected_to movie_path(movie)
    follow_redirect!
    assert_select "h1", text: "New Story"
    assert_select ".synopsis", text: /An original story/
    assert_select "time[datetime='2005-06-07']"
    assert_select "form input[name=_method][value=delete]"

    get edit_movie_path(movie)
    assert_response :success
    assert_select "input[name='movie[title]'][value='New Story']"
    patch movie_path(movie), params: { movie: { title: "Revised Story", rating: "R", release_date: "2006-07-08", description: "A revised story." } }
    assert_redirected_to movie_path(movie)
    movie.reload
    assert_equal "Revised Story", movie.title
    assert_equal "R", movie.rating
    assert_equal Date.new(2006, 7, 8), movie.release_date.to_date
    assert_equal "A revised story.", movie.description

    assert_difference "Movie.count", -1 do
      delete movie_path(movie)
    end
    assert_redirected_to movies_path
    follow_redirect!
    assert_select ".flash-notice", text: /Revised Story was deleted/
    assert_not Movie.exists?(movie.id)
  end

  test "sort selection survives all movie pages and CRUD operations" do
    get movies_path, params: { sort: "release_date", direction: "desc" }
    [ movie_path(@aster), new_movie_path, edit_movie_path(@aster) ].each do |path|
      get path
      assert_response :success
      assert_saved_sort
    end

    post movies_path, params: { movie: { title: "Dahlia", rating: "PG", release_date: "2010-01-01" } }
    assert_response :see_other
    follow_redirect!
    assert_saved_sort
    assert_equal %w[Birch Aster Dahlia Cedar], titles_on_page

    patch movie_path(@aster), params: { movie: { release_date: "2025-01-01" } }
    assert_response :see_other
    assert_saved_sort
    assert_equal %w[Aster Birch Dahlia Cedar], titles_on_page

    delete movie_path(@aster)
    assert_saved_sort
    assert_equal %w[Birch Dahlia Cedar], titles_on_page
  end

  test "invalid input preserves data and displays form errors" do
    assert_no_difference "Movie.count" do
      post movies_path, params: { movie: { title: " ", rating: "unknown", release_date: "" } }
    end
    assert_response :unprocessable_entity
    assert_select ".error-summary[role=alert]"

    patch movie_path(@aster), params: { movie: { title: "", rating: "G" } }
    assert_response :unprocessable_entity
    assert_equal "Aster", @aster.reload.title
    assert_equal "R", @aster.rating
  end

  test "untrusted sort parameters use safe defaults" do
    get movies_path, params: { sort: "title; DROP TABLE movies", direction: "not-a-direction" }
    assert_response :success
    assert_equal %w[Aster Birch Cedar], titles_on_page
    assert_equal 3, Movie.count
    get movies_path, params: { sort: [ "rating" ], direction: [ "desc" ] }
    assert_response :success
    assert_equal %w[Aster Birch Cedar], titles_on_page
  end

  test "missing movies return 404" do
    get movie_path(id: 0)
    assert_response :not_found
  end

  test "empty collection offers a link to add a movie" do
    Movie.delete_all
    get movies_path
    assert_response :success
    assert_select ".empty-state a[href=?]", new_movie_path
    assert_select "tfoot", text: /0 movies/
  end

  test "movie content cannot inject scripts into rendered pages" do
    @aster.update!(title: "<script>alert(1)</script>", description: "<script>alert(2)</script>Readable story")
    get movie_path(@aster)
    assert_response :success
    assert_select "script", count: 0
    assert_select ".synopsis", text: /Readable story/
  end

  private

  def titles_on_page
    css_select("tbody .movie-title a").map(&:text)
  end

  def assert_saved_sort
    get movies_path
    assert_response :success
    assert_select "th[aria-sort=descending]", text: /Release date/
  end
end
