class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def logged_in_user
    unless logged_in?
     store_location
     flash[:danger] = "ログインしてください。"
     redirect_to login_url
    end
  end
   
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end
   
  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def set_one_month
    if params[:first_day].nil?
      @first_day = Date.today.beginning_of_month
    else
      @first_day = Date.parse(params[:first_day])
    end
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] 
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day)
     unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
     end

  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
end
    