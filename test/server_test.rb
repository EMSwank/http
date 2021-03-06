require 'minitest/autorun'
require 'minitest/pride'
require './lib/server'
require 'Faraday'

class ServerTest < Minitest::Test
  def test_it_exists
    server = Server.new

    assert_instance_of Server, server
  end

  def test_it_can_get_lines_to_array
    server = Server.new
    expected = ["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive", "Upgrade-Insecure-Requests: 1", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8", "Accept-Encoding: gzip, deflate, br", "Accept-Language: en-US,en;q=0.9"]

    assert_eqaul expected, server.request_lines

  end
end
