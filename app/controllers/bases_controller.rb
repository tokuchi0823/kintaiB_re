class BasesController < ApplicationController
  before_action :admin_user, only: [:index, :delete, :update, :create]
   
  def new
  end
  
  def index
    @base = Base.all
  end
  
  def edit 
    @base = Base.find(params[:id])
  end
  
  def update
    @base = Base.find(params[:id])
    if @base.update_attributes(base_params)
      flash[:success] = "拠点を更新しました。"
      redirect_to bases_url(@base)
    else
      render :edit
    end
  end
  
   private

    def base_params
      params.require(:base).permit(:base_no, :base_name, :base_type)
    end
end
