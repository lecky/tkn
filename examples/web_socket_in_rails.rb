# encoding: utf-8

center <<-EOS
  WebSocket in Ruby on Rails

  Lecky Lao(@leckylao)

  RORO 11-02-2013
EOS

section "Can I use WebSocket?" do
  center "http://caniuse.com/#feat=websockets"
end

section "WebSocket fallback" do
  code <<-EOS
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
    }
  EOS
end

block <<-EOS
  Dependencies:

    * gem 'sidekiq'

    * gem 'websocket-eventmachine-client'

    * gem 'tubesock'
EOS

section "Sidekiq -C config/sidekiq.yml" do
  code <<-EOS
    class RedisWorker
      def notify
      end
    end
  EOS
end

section "WebSocket Eventmachine Client" do
  code <<-EOS
    EM.run do

      ws = WebSocket::EventMachine::Client.connect(:uri => 'ws://localhost:8080')

      ws.onopen do
        puts "Connected"
      end

      ws.onmessage do |msg, type|
        puts "Received message: \#{msg}"
      end

      ws.onclose do
        puts "Disconnected"
      end

      EventMachine.next_tick do
        ws.send "Hello Server!"
      end

    end
  EOS
end

section "----Tubesock----" do
  center <<-EOS
    Tubesock lets you use websockets from rack and rails 4+

    by using Rack's new hijack interface to access the underlying socket connection.

    In contrast to other websocket libraries

    Tubesock does not use a reactor (read: no eventmachine)

    Instead, it leverages Rails 4's new full-stack concurrency support

    Note that this means you must use a concurrent server. We recommend Puma > 2.0.0

    - Tubesock
  EOS

  code <<-EOS
    class ChatController < ApplicationController
      include Tubesock::Hijack

      def chat
        hijack do |tubesock|
          tubesock.onopen do
            tubesock.send_data "Hello, friend"
          end

          tubesock.onmessage do |data|
            tubesock.send_data "You said: \#{data}"
          end
        end
      end
    end
  EOS
end

section "----Demo----" do
end

section "Problems I've faced:" do
  block <<-EOS
    1. Message only appear when browser is opened

      * Check publish count

    2. Message disappeared when switching pages

      * Having a history of messages
  EOS
end

section "That's all, thanks!

slide using tkn(https://github.com/fxn/tkn) and gisted on:

leckylao/web_sockets_in_rails.rb" do
end

__END__
