# This server reads a löine of input from a client, does something and then sends
# a response. If the client sends the string "quit" it disconnects
# it handles multiple connections/session
require 'socket'

server = TCPServer.open(2000)
sockets = [server]
log = STDOUT
while true
  ready = select(sockets)
  readable = ready[0]
  readable.each do |socket|
    if socket == server
      client = server.accept
      sockets << client
      # Tell the client what and where it has connected
      client.puts "Conflict service v0.01 running #{Socket.gethostname}"
      # and log the fact that the client connected
      log.puts "Accepted connection from #{client.peeraddr[2]}"
    else                  #otherwise a client has connected
      input = socket.gets #Read input from the client
      
      # If no input, the client disconnected
      if !input
        puts "3"
        log.puts "Client on #{socket.peeraddr[2]} disconnected."
        sockets.delete(socket)  #remove client from monitored clients
        socket.close
        next
      end
      
      input.chop!               #trim the clients input
      if (input == "quit")
        socket.puts("bye!")
        log.puts "Closing connection to #{socket.peeraddr[2]}"
        sockets.delete(socket)  #bye bye socket
        socket.close
      else
        socket.puts("message acknowledged (#{input})")
      end
    end
  end
end
