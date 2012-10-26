class LabelElementsController < AdminController
  before_filter :labels_all, :only => [:index, :new, :edit]


  # GET /label_elements
  # GET /label_elements.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @label_elements }
    end
  end

  # GET /label_elements/1
  # GET /label_elements/1.json
  def show
    @label_element = LabelElement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @label_element }
    end
  end

  # GET /label_elements/new
  # GET /label_elements/new.json
  def new
    @label_element = LabelElement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @label_element }
    end
  end

  # GET /label_elements/1/edit
  def edit
    @label_element = LabelElement.active.find params[:id]
  end

  # POST /label_elements
  # POST /label_elements.json
  def create
    @label_element = LabelElement.new(params[:label_element])
    @label_element.belongs = params[:belongs]

    @label_element.save!
    redirect_to @label_element, notice: 'Label was successfully created.'
  rescue Exception => e
    logger.error e
    labels_all
    render action: "new"
  end

  # PUT /label_elements/1
  # PUT /label_elements/1.json
  def update
    @label_element = LabelElement.find(params[:id])
    @label_element.belongs = params[:belongs]

    @label_element.update_attributes!(params[:label_element])
    redirect_to @label_element, notice: 'Label was successfully updated.'
  rescue Exception => e
    logger.error e
    labels_all
    render action: "edit"
  end

  # DELETE /label_elements/1
  # DELETE /label_elements/1.json
  def destroy
    @label_element = LabelElement.find(params[:id])
    @label_element.destroy

    redirect_to label_elements_url
  end


  private

  def labels_all
    @label_elements = LabelElement.active.order 'updated_at DESC'
  end
end
