class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  # GET /microposts/1/edit
  def edit
  end

  # POST /microposts
  # POST /microposts.json
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])

    respond_to do |format|
      if @micropost.save
        flash[:success] = "Micropost created!"
        format.html { redirect_to root_url }
        format.json { render :show, status: :created, location: @micropost }
      else
        @feed_items = current_user.feed.paginate(page: params[:page])
        format.html { render 'static_pages/home' }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /microposts/1
  # DELETE /microposts/1.json
  def destroy
    @micropost.destroy
    respond_to do |format|
      flash[:success] = "Micropost deleted"
      format.html { redirect_to request.referrer || root_url }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
