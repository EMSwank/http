require 'socket'
tcp_server = TCPServer.new(9292)
client = tcp_server.accept

puts "Ready for a request"
request_lines = []

while line = client.gets and !line.chomp.empty?
  request_lines << line.chomp
end

puts "Got this request:"
puts request_lines.inspect

puts "Sending response."
response = "<pre>" + request_lines.join("\n") + "</pre>"
output = "<html><head></head><body>#{response}</body></html>"
headers = ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{output.length}\r\n\r\n"].join("\r\n")
client.puts headers
client.puts output

puts ["Wrote this response:", headers, output].join("\n")
client.close
puts "\nResponse complete, exiting."


"GET / HTTP/1.1",
"Host: 127.0.0.1:9292",
"Connection: keep-alive",
"Cache-Control: no-cache",
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.167 Safari/537.36
Postman-Token: e866cffb-2853-39b1-7383-1f185bbecef4
Accept: */*
Accept-Encoding: gzip, deflate, br
Accept-Language: en-US,en;q=0.9"
