class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:destroy]

  # GET /companies
  # GET /companies.json
  def index
    if params[:status]
      @status = params[:status]
    else
      @status = 2
    end

    @companies = Company.where(status: @status)
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    remember_company @company
    @time_trackings = @company.time_trackings.where("date >= ?", Date.today.beginning_of_month).where("date <= ?", Date.today.end_of_month)
  end

  def calendar
    @start_date = nil
    @start_date = params["start_date"] if params["start_date"]
    @company = current_company
  end

  def client_information
    @company = current_company
  end

  def client_contacts
    @company = current_company
  end

  def content_distribution
    @posts = current_company.posts.where("start_time >= ?", Date.today.beginning_of_month).where("start_time <= ?", Date.today.end_of_month)
  end

  def create_post_report
    @company = current_company

    if params["start_date"]
      @calendar_date = Date.parse(params["start_date"])
    else
      @calendar_date = Date.today
    end

    @posts = @company.posts.where("start_time >= ?", @calendar_date.beginning_of_month).where("start_time <= ?", @calendar_date.end_of_month)
    print "Posts: " + @posts.to_s
    respond_to do |format|
      format.pdf do
        render  pdf: 'report',
                layout: 'layouts/pdf.html',
                template: 'companies/posts.pdf.erb',
                encoding: "UTF-8",
                :margin => {:top                => 15,
                            :bottom             => 10,
                            :left               => 20,
                            :right              => 20},
                :footer => {
                  :content => render_to_string(:template => 'layouts/footer.pdf.erb')
                }
      end
    end
  end

  # GET /companies/new
  def new
    @company = Company.new
    respond_to do |format|
      format.html # new.html.erb
      format.js # new.js.erb
    end
  end

  # GET /companies/1/edit
  def edit
    respond_to do |format|
      format.html # edit.html.erb
      format.js # edit.js.erb
    end
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)
    @company.create_social_id
    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        remember_company(@company)
        format.html { redirect_to "/client_information", notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    destroy_facebook_insights
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # destroy collections of facebook insights
    def destroy_facebook_insights
      name = @company.name.split.join
      FacebookInsights.destroy_collection(name)
      FacebookInsights.destroy_collection(name.to_s + "_posts")
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :description, :lead_source, :job_types, :website,
                                      :monthly_total, :address, :status, :total_hours, :one_time_cost,
                                      :facebook, :twitter, :linkedin, :instagram, :notes)
    end
end
