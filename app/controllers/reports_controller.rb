# encoding: utf-8

class ReportsController < AdminController
  # GET /reports
  # GET /reports.json
  def index
    @reports    = Report.active.order "status, created_at DESC"
    @unresolves = Report.unresolves
  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(params[:report].merge({:author_id => @author.id}))

    respond_to do |format|
      if @report.save
        format.html do
          redirect_to "#{params[:return_url]}&under_survey=on" , notice: '投稿を受け付けました。'
        end
      else
        format.html do
          redirect_to "#{params[:return_url]}&under_survey=false", notice: '投稿を受け付けることができませんでした。'
        end
      end
    end
  end

  # PUT /reports/1
  # PUT /reports/1.json
  def update
    @report = Report.find params[:id]

    respond_to do |format|
      if @report.update_attributes params[:report].merge({:resolver_id => @author.id})
        format.html do
          redirect_to reports_path, notice: 'Report number ##{@report.id} was successfully updated.'
        end
      else
        format.html do
          render action: "edit"
        end
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    respond_to do |format|
      format.html { redirect_to reports_url }
      format.json { head :no_content }
    end
  end


  protected

  def logged_into_admin(author)
    if action_name == 'create'
      return author
    end
    super
  end
end
