require "date"

class Public < Sinatra::Base
  get '/attendances' do
    @attendances = Attendance.all
    haml :"attendances/index"
  end
  # idmの登録を確認
  post '/attendances/is-exists-idm' do
    params =  JSON.parse(request.body.read)
    result = User.where(idm: params["idm"]).exists?
    {result: result}.to_json
  end

  post '/last-attend-time' do
    params = JSON.parse(request.body.read)
    user_attendance = User.find_by(idm: params["idm"]).attendances.last
    result = (user_attendance.record_time + 1.minute) < Time.now
    {result: result}.to_json
    # falseだったら1分以内にタッチされた
  end
end

class Protect < Sinatra::Base
  # 出席の登録
  post '/attendances/create' do
    params =  JSON.parse(request.body.read)
    user = User.find_by(idm: params["idm"])
    status = judge(user)
    attendance = Attendance.new(
      user: user,
      record_time: params["datetime"],
      status: status
    )
    p attendance
    if attendance.save
      {stauts: status}.to_json
    else
      {stauts: "error"}.to_json
    end
  end

  private

  def judge(user)
    unless user.attendances.last
      return 0
    else
      if Date.today > user.attendances.last.record_time
        return 0
      else
        case user.attendances.last.status
        when "enter" then
          return 1
        when "left" then
          return 0
        else 
          return 0
        end
      end
    end
  end

end
