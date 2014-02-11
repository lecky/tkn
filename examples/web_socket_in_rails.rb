# encoding: utf-8

red = "\e[31;1m"
green = "\e[32;1m"
yellow = "\e[33;1m"
blue = "\e[34;1m"
magenta = "\e[35;1m"
cyan = "\e[36;1m"
@reset = "\e[0m"
@colors = [red, green, yellow, blue, magenta, cyan]

def color
  %(#{@reset}#{@colors.sample})
end

center <<-EOS
  #{color}WebSocket in Ruby on Rails


  Lecky Lao
  @leckylao

  RORO 11-02-2013#{color}
EOS

section "Can I use WebSocket?" do
  center "#{color}http://caniuse.com/#feat=websockets#{color}"
end

section "WebSocket fallback" do
  code <<-EOS
    #{color}
    function (){
      var socket = new WebSocket "ws://" + window.location.host + "/subscribe";
      socket.onerror = function() {
         alert('Not supported');
         // Use Ajax long poll
      }
      socket.onmessage = function(e) {
        $("#message").append( status_start + status_class + message_start + data.message );
      }
      socket.onclose = function() {
          alert('Not supported');
         // Use Ajax long poll
      }
    }#{color}
  EOS
end

block <<-EOS
  Dependencies:

  * gem 'websocket-eventmachine-client'

  * gem 'tubesock'

  * gem 'sidekiq'
EOS

section "That's all, thanks!" do
end

__END__
