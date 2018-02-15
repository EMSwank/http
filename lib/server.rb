require 'socket'

class Server

  def initialize
    @tcp_server = TCPServer.new(9292)
    @hello_counter = 0
    @counter = 0
    @request_lines = []
  end

  def listen
    puts "Ready for request"
    @client = @tcp_server.accept
  end

  def get_request_lines
    loop do
      listen
      while line = @client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end
      require 'pry'; binding.pry
      response
    end
  end

  def request
    puts "Got this request:"
    puts @request_lines.inspect
  end

  def response
    puts "Sending response."
    response = "<pre>" + "#{supporting_paths}" + ("\n") + "</pre>"
    puts @request_lines
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{date_time}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    @client.puts headers
    @client.puts output
  end

  def date_time
    @counter += 1
    "#{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}"
  end

  def hello_world
    @hello_counter += 1
    @counter += 1
    "Hello, world! (#{@hello_counter})"
    end
  end

  def shutdown
    @counter += 1
    "Total requests: #{@counter}"
  end

  def close_connection
    puts ["Wrote this response:", headers, output].join("\n")
    # @client.close
    puts "\nResponse complete, exiting."
  end

  def parse
    @verb = @request_lines[0].split(" ")[0]
    @path = @request_lines[0].split(" ")[1]
    @protocol = @request_lines[0].split(" ")[2]
    @host = @request_lines[1].split(" ")[1].split(":")[0]
    @port = @request_lines[1].split(" ")[1].split(":")[1]
    @origin = @host
    @accept = @request_lines[8]
  end

  def supporting_paths
    hello_world if @path == "/hello"
    date_time if @path == "/datetime"
    shutdown if @path == "/shutdown"
  end
end
