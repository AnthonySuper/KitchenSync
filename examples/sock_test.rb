require 'socket'
require 'bundler'

Bundler.require

serv = Socket.new(:INET, :STREAM, 0)
serv.listen(5)
c = Socket.new(:INET, :STREAM, 0)
c.connect(serv.connect_address)

Ballet::EventManager.run do
  async do
    Ballet::Socket.use(c) do |sock|
      read = sock.read(1000).await
      puts "I read '#{read}' from socket"
    end
  end

  async do
    s, info = serv.accept
    Ballet::Socket.use(s) do |sock|
      res = sock.write(%q{
                       This is a test of socket writing.
                       I don't know how it works.
                       Maybe it doesn't!}).await
      puts res
    end
  end
end
