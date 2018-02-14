require 'socket'

class Server

  def initialize
    @tcp_server = TCPServer.new(9292)
    @hello_counter = 0
  end

  def listen
    puts "Ready for request"
    client = @tcp_server.accept
  end

  def get_request_lines
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def request
    puts "Got this request:"
    puts request_lines.inspect
  end

  def response
    puts "Sending response."
    response = "<pre>" + request_lines.join("\n") + "</pre>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{date_time}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
  end

  def date_time
    "#{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}"
  end

  def hello_world
    @hello_counter += 1
    "Hello, world! (#{@hello_counter})"
  end

  def close_connection
    puts ["Wrote this response:", headers, output].join("\n")
    client.close
    puts "\nResponse complete, exiting."
  end
end
