require 'socket'

host, port = ARGV
begin
  #feedback while connecting
  STDOUT.print "Connecting..."
  STDOUT.flush
  s = TCPSocket.open(host, port )
  puts "Done"
  
  #Print some connection information
  local, peer = s.addr, s.peeraddr
  STDOUT.print "Connected to #{peer[2]}:#{peer[1]}"
  STDOUT.puts " using local port #{local[1]}"
  
  #wait for 
  begin
    sleep(0.5)
    msg = s.read_nonblock(4096)
    STDOUT.puts msg.chop
  rescue SystemCallError
  # I ignore any exception here
  end
  
  #Start some interaction client/server
  loop do
  STDOUT.print '>'
  STDOUT.flush
  local = STDIN.gets
  break if !local
  
  s.puts(local)
  s.flush
  
  #read server response and print it
  #response may be multi line so using readpartial
  response = s.readpartial(4096)
  puts(response.chop)
end
rescue  #if something goes to hell
  puts $!
ensure
  s.close if s
end
  loop do
end

s.close
