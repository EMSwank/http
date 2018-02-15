require './lib/server'

server = Server.new

# until server.path == "/shutdown"
#   client = server.listen
#   request = server.get_request_lines
#   server.parse
#   server.request
#   server.response
#   client.close

# end
server.get_request_lines
