class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:destroy]

  # GET /companies
  # GET /companies.json
  def index
    if params[:show_lost]
      @show_lost = params[:show_lost]
    else
      @show_lost = false
    end

    @companies = Company.all
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    remember_company @company
    @time_trackings = @company.time_trackings.where("date >= ?", Date.today.beginning_of_month).where("date <= ?", Date.today.end_of_month)
  end

  def calendar
    @company = current_company
  end

  def client_information
    @company = current_company
  end

  def client_contacts
    @company = current_company
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
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
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
      params.require(:company).permit(:name, :description, :lead_source, :job_types, :website, :monthly_total, :address, :lost, :total_hours)
    end
end
