REDISCLOUD_URL = 'redis://rediscloud:ztdraXsbrwrCnCj1@pub-redis-18263.us-east-1-2.3.ec2.garantiadata.com:18263'

if REDISCLOUD_URL
    uri = URI.parse(REDISCLOUD_URL)
    $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end
