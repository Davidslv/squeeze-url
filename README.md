# Squeeze URL

A simple url shortener written in [sinatra.rb](https://sinatra.rb)

# Setup

```
  bundle install
```

# Run

```
  ruby app.rb
```

# Create a new short url

```
  curl localhost:4000 -XPOST -d '{ "url": "http://www.helloworld.com" }'
  > {"short_url":"lh3lYL","url":"http://www.helloworld.com"}
```

# Request with short url

```
  curl -v localhost:4000/lh3lYL

  * TCP_NODELAY set
  * Connected to localhost (::1) port 4000 (#0)
  > GET /lh3lYL HTTP/1.1
  > Host: localhost:4000
  > User-Agent: curl/7.51.0
  > Accept: */*
  >
  < HTTP/1.1 301 Moved Permanently
  < Content-Type: text/html;charset=utf-8
  < Location: http://www.helloworld.com
  < Content-Length: 33
  < X-Xss-Protection: 1; mode=block
  < X-Content-Type-Options: nosniff
  < X-Frame-Options: SAMEORIGIN
  < Server: WEBrick/1.3.1 (Ruby/2.4.2/2017-09-14)
  < Date: Fri, 05 Jan 2018 14:07:15 GMT
  < Connection: Keep-Alive
  <
  * Curl_http_done: called premature == 0
  * Connection #0 to host localhost left intact
  {"url":"http://www.helloworld.com"}
```
