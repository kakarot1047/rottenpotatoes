class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    # Remember the sort across visits. If the user comes back with no sort params
    # but we have a saved sort, redirect so the URL reflects the state (RESTful).
    if params[:sort].blank? && session[:sort].present?
      flash.keep   # don't lose "Movie was successfully destroyed." etc.
      return redirect_to movies_path(sort: session[:sort], direction: session[:direction])
    end

    @sort_column    = Movie::SORTABLE_COLUMNS.include?(params[:sort]) ? params[:sort] : nil
    @sort_direction = params[:direction] == "desc" ? "desc" : "asc"
    session[:sort]      = @sort_column
    session[:direction] = @sort_direction

    @movies = Movie.sorted_by(@sort_column, @sort_direction)
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @movie.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @movie.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, notice: "Movie was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.expect(movie: [ :title, :rating, :director, :description, :release_date, :stars ])
    end
end
