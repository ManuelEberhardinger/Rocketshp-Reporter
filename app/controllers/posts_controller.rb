class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.js # show.js.erb
    end
  end

  # GET /posts/new
  def new
    @post = Post.new params[:post] ? post_params : {}
    @post.company_id = current_company.id
    respond_to do |format|
      format.html # new.html.erb
      format.js # new.js.erb
    end
  end

  # GET /posts/1/edit
  def edit
    respond_to do |format|
      format.html # edit.html.erb
      format.js # edit.js.erb
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to "/companies_calendar?start_date=" + @post.start_time.to_s, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to "/companies_calendar?start_date=" + @post.start_time.to_s, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    company = @post.company
    @post.destroy
    respond_to do |format|
      format.html { redirect_to company, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:company_id, :post_type, :start_time, :post, :title)
    end
end
