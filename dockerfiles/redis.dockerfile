FROM redis:latest

COPY redis.conf /usr/local/etc/redis/redis.conf

CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]


# docker run -v /myredis/conf:/usr/local/etc/redis -- name myredis redis redis-server /usr/local/etc/redis/redis.conf
#
#

