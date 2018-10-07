class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    ratings = @company.ratings
    @data = {}
    ratings.each do |rating|
      rating.columns.each do |column|
        @data[column] = [] if !@data[column]
        @data[column] << rating[column] if rating[column]
      end
    end
    @data = @data.map{|k,v| [k,v.sum.to_f/v.count]}.to_h
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

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
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def approvals
    @users = User.where(company: current_user.company).with_role :applied
  end

  def approve
    @user = User.find params[:user_id]
    @user.remove_role :applied
    @user.add_role :employee
    redirect_to applications_company_path
  end

  def rate
    @company = Company.find params[:company_id]
    # @rating = Rating.where(company: @company, user: current_user ).first
    @rating = @company.ratings.build if !@rating

    if current_user.has_role?(:employee) and current_user.company == @company
      @columns = @rating.columns[10..15]
    elsif current_user.has_role? :professional
      @columns = @rating.columns[5..9]
    else
      @columns = @rating.columns[0..4]
    end

  end

  def save_rating
    company = Company.find params[:rating][:company_id]
    rating = Rating.where(company: company, user: current_user ).first
    rating = Rating.new if !rating
    rating.company = company
    params[:rating].each do |key, val|
      next if key.to_sym == :company_id
      next if val == val.to_i
      rating.programs = val if key == "programs"
      rating.community_involvement = val if key == "community_involvement"
      rating.misdemeanors = val if key == "misdemeanors"
      rating.average_wage = val if key == "average_wage"
      rating.employee_benefits = val if key == "employee_benefits"
      rating.background_checks = val if key == "background_checks"
      rating.finances = val if key == "finances"
      rating.discrimination = val if key == "discrimination"
      rating.hiring_process = val if key == "hiring_process"
      rating.legality = val if key == "legality"
      rating.peer_relations = val if key == "peer_relations"
      rating.management = val if key == "management"
      rating.workload = val if key == "workload"
      rating.hr_cooperation = val if key == "hr_cooperation"
      rating.work_conditions = val if key == "work_conditions"
    end
    rating.user = current_user
    current_user.add_points company
    rating.save!
    Rails.logger.debug(rating.to_json)
    flash[:notice] = "Your Rating has been saved"
    redirect_to rate_company_path(rating.company)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:title, :description, :programs,
        :community_involvement,
        :misdemeanors,
        :average_wage,
        :employee_benefits,
        :background_checks,
        :finances,
        :discrimination,
        :hiring_process,
        :legality,
        :peer_relations,
        :management,
        :workload,
        :hr_cooperation,
        :work_conditions,
        :ratings)
    end
end
