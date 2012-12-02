require 'socket'
require_relative './romancalc.rb'

def handle_client(c)
  while true
    input = c.gets.chop
    # break if !input
    break if input == 'quit' or input == 'exit'
    calc = Calc.new
    c.puts calc.calculate(input)
    c.flush
  end
  c.close
end

server = TCPServer.open(2000)

while true
  client = server.accept
  Thread.start(client) do |c|
    handle_client(c)
  end
end
