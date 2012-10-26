class MoviesController < AdminController

  EACH_LIMIT_WHEN_SEARCH = 50

  # GET /movies
  # GET /movies.json
  def index
    movie_params = params[:movies] || {}
    if movie_params[:page].blank?
      movie_params[:page] = 0
    end

    @movies = Movie.search movie_params[:word], 0, EACH_LIMIT_WHEN_SEARCH do |response|
      @movies_count = response['numFound']
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @movies }
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie }
    end
  end

  # GET /movies/new
  # GET /movies/new.json
  def new
    @movie = Movie.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find params[:id]
  end

  # POST /movies
  def create
    @movie = Movie.new params[:movie]
    @movie.attributes = params[:attributes]

    @movie.save!
    redirect_to @movie, notice: 'Movie was successfully created.'
  rescue Exception => e
    logger.error e
    render action: "new"
  end

  # PUT /movies/1
  def update
    @movie = Movie.find params[:id]
    @movie.attributes = params[:attributes]

    @movie.update_attributes! params[:movie]
    redirect_to @movie, notice: 'Movie was successfully updated.'
  rescue Exception => e
    logger.error e
    render action: "edit"
  end

  # DELETE /movies/1
  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy

    redirect_to movies_url
  end


  protected

  def logged_in?
    author = super
    logged_into_admin author
  end
end
