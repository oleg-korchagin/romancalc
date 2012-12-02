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
    calc = Calc.new
    while true
      input = c.gets
      c.puts calc.calculate(input)
      c.flush
    end
    c.close
  end

end

port = ARGV[0] || 2000
STDOUT.puts "Starting server on port #{port} ..."
Server.new(port).run
