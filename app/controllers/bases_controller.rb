class BasesController < ApplicationController
  before_action :admin_user, only: [:index, :delete, :update, :create]
   
  def new
    @base = Base.new
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
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = '新規作成に成功しました。'
      redirect_to bases_url(@base)
    else
      render :new
    end
  end

  def destroy
    @base = Base.find(params[:id])
    @base.destroy
    flash[:success] = "拠点を削除しました。"
    redirect_to bases_url(@base)
  end
  
    private

    def base_params
      params.require(:base).permit(:base_no, :base_name, :base_type)
    end
end
