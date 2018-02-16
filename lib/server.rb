require 'socket'
require 'pry'

class Server
  attr_reader :path, :header

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
      response
    end
  end

  def request
    puts "Got this request:"
    puts @request_lines.inspect
  end

  def response
    puts "Sending response."
    parse
    response = "<pre>" + "#{supporting_paths}" + ("\n") + "</pre>"
    # puts @request_lines
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{date_time}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    @client.puts headers
    @client.puts output
  end

  def response_header
    @header = ["http/1.1 200 ok",
              "date: #{date_time}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def date_time
    # @counter += 1
    "#{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}"
  end

  def hello_world
    @hello_counter += 1
    @counter += 1
    return "Hello, world! (#{@hello_counter})"
  end

  def shutdown
    @counter += 1
    return "Total requests: #{@counter}"
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

  def word_lookup
    word_to_lookup = @request_lines.find {|request| request.include?('?')}
    actual = word_to_lookup.split("=")[1].split[0]
    dict = File.read("/usr/share/dict/words")
    if dict.include?(actual)
      return "#{actual} is a known word"
    else
      return "#{actual} is not a known word"
    end
  end

  def supporting_paths
    if @path == '/'
      parse
    elsif @path == "/hello"
      hello_world
    elsif @path == "/datetime"
      date_time
    elsif @path.include?("/word_search") && @verb == "GET"
        word_lookup
    elsif @path == '/game' && @verb == 'POST'
    else @path == "/shutdown"
      shutdown
    end
  end
end
