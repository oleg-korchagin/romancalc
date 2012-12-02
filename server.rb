require 'socket'
require_relative './romancalc.rb'

class Server

  def initialize port
    @server = TCPServer.open port
  end

  def run
    while true
      client = @server.accept
      Thread.start(client) do |c|
        handle_client(c)
      end
    end
  end

  private

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

end

server = Server.new(2000)
server.run
