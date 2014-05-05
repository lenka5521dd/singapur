class ApplicationController < ActionController::Base
  # after_filter :set_online
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def set_online
    if !!current_user
      $redis.pipelined do
        # вошедшему пользователю к ключу добавляем префикс "user:" перед id
        $redis.set( "user:#{current_user.id}", nil )
        $redis.expire( "user:#{current_user.id}", 10*60 )
      end
    else
      $redis.pipelined do
        # не вошедшему пользователю добавляем префикс "ip:" и записываем его id адрес
        $redis.set( "ip:#{request.remote_ip}", nil )
        $redis.expire( "ip:#{request.remote_ip}", 10*60 )
      end
    end
  end
end




# $redis.sadd 'online', '123321123321'
# $redis.smembers 'online'
# $redis.sismember 'online', '5328486e69702d1a770b000'
