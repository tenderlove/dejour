$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require "dnssd"
require 'ruby-growl'

Thread.abort_on_exception = true

module Dejour
  USER_CONFIG = ENV['HOME'] + "/.dejour"

  KNOWN_SERVICES = Hash.new { |h,k|
    h[k] = lambda { |reply, rr|
      [k, k]
    }
  }
  KNOWN_SERVICES['git'] = lambda { |reply, rr|
    [ "git repository", "gitjour clone #{reply.name}" ]
  }
  KNOWN_SERVICES['pastejour'] = lambda { |reply, rr|
    (from, to) = *reply.name.split('-')
    ['pastejour', "Paste from #{from} to #{to}"]
  }
  KNOWN_SERVICES['rubygems'] = lambda { |reply, rr|
    ['gemjour', "gem server #{reply.name}"]
  }

  NOTIFICATION_NAME = 'ruby-growl Notification'
  def self.find(password = nil, *names)
    g = Growl.new('localhost', 'ruby-growl', [NOTIFICATION_NAME], nil, password)
    seen_services = Hash.new { |h,k| h[k] = {} }
    mutex = Mutex.new
    seen_error_msg = false
    services = names.map do |name|
      DNSSD.browse("_#{name}._tcp") do |reply|
        DNSSD.resolve(reply.name, reply.type, reply.domain) do |rr|
          mutex.synchronize {
            unless seen_services[name].key?(reply.name)
              seen_services[name][reply.name] = true
              begin
                g.notify( NOTIFICATION_NAME,
                         *KNOWN_SERVICES[name].call(reply, rr)
                        )
              rescue
                puts <<-EOS unless seen_error_msg
You may not have Growl + ruby-growl installed correctly.

Get Growl from:
  http://growl.info/
  
Get ruby-growl from:
  sudo gem install ruby-growl

Then (for OS X) you need to enable "Listen for incoming notifications" and 
"Allow remote application registration" on the Network tab of the 
Growl Preference Panel to send Growl Notifications from ruby-growl.

                EOS
                seen_error_msg = true
                STDERR.puts KNOWN_SERVICES[name].call(reply, rr).join(": ")
              end
            end
          }
        end
      end
    end

    services.each { |s| s.instance_variable_get(:@thread).join }
  end
end
