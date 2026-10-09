class MoviesController < ApplicationController
  before_action :set_movie, only: %i[show edit update destroy]

  def index
    @sort = valid_choice(params[:sort], session[:movie_sort], Movie::SORT_COLUMNS, "title")
    @direction = valid_choice(params[:direction], session[:movie_direction], Movie::SORT_DIRECTIONS, "asc")
    session[:movie_sort] = @sort
    session[:movie_direction] = @direction
    @movies = Movie.sorted(@sort, @direction)
  end

  def show
  end

  def new
    @movie = Movie.new
  end

  def edit
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to movie_path(@movie), notice: "#{@movie.title} was added.", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @movie.update(movie_params)
      redirect_to movie_path(@movie), notice: "#{@movie.title} was updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy!
    redirect_to movies_path, notice: "#{@movie.title} was deleted.", status: :see_other
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def movie_params
    params.expect(movie: [ :title, :rating, :description, :release_date ])
  end

  def valid_choice(requested, saved, choices, fallback)
    return requested if choices.include?(requested)
    return saved if choices.include?(saved)

    fallback
  end
end
