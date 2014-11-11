class MicropostsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user, 	 only: [:destroy, :picture]
	
	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end
	
	def destroy
		@micropost.destroy
		flash[:success] = "Micropost deleted"
		redirect_to request.referrer || root_url
	end
	
	def picture
		content = @micropost.picture.read
    if stale?(etag: content, last_modified: @micropost.updated_at.utc, public: true)
      send_data content, type: @micropost.picture.file.content_type, disposition: "inline"
      expires_in 0, public: true
    end
	end
	
		private
	
		def micropost_params
			params.require(:micropost).permit(:content, :picture)
		end
		
		def correct_user
			@micropost = current_user.microposts.find_by(_id: params[:id])
			redirect_to root_url if @micropost.nil?
		end
end
