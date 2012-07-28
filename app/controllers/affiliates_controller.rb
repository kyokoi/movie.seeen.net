class AffiliatesController < AdminController
  before_filter :fixed_movie


  # GET /affiliates
  # GET /affiliates.json
  def index
    @affiliates = Affiliate.where :movie_id => @movie.id

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @affiliates }
    end
  end

  # GET /affiliates/new
  # GET /affiliates/new.json
  def new
    @affiliate = Affiliate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @affiliate }
    end
  end

  # GET /affiliates/1/edit
  def edit
    @affiliate = Affiliate.find(params[:id])
  end

  # POST /affiliates
  # POST /affiliates.json
  def create
    @affiliate = Affiliate.new(params[:affiliate])

    respond_to do |format|
      if @affiliate.save
        format.html { redirect_to movie_path(@movie), notice: 'Affiliate was successfully created.' }
        format.json { render json: @affiliate, status: :created, location: @affiliate }
      else
        format.html { render action: "new" }
        format.json { render json: @affiliate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /affiliates/1
  # PUT /affiliates/1.json
  def update
    @affiliate = Affiliate.find(params[:id])

    respond_to do |format|
      if @affiliate.update_attributes(params[:affiliate])
        format.html { redirect_to movie_path(@movie), notice: 'Affiliate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @affiliate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /affiliates/1
  # DELETE /affiliates/1.json
  def destroy
    @affiliate = Affiliate.find(params[:id])
    @affiliate.destroy

    respond_to do |format|
      format.html { redirect_to movie_path(@movie) }
      format.json { head :no_content }
    end
  end


  private

  def fixed_movie
    @movie = Movie.find_by_id_and_negative(params[:movie_id], 0)
  end
end
