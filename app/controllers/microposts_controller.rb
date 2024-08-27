class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  def create
    @micropost = @current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      flash[:danger] = "There was an issue creating your micropost."
      redirect_to users_path(id: @current_user.id, page: 0)
    end
  end
  def destroy
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
