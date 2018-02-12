require 'socket'
# require 'tcpserver'

class Server
  attr_reader :port

  def initialize
    @port = TCPServer.new(9292)
  end
end
