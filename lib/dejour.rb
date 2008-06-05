require 'rubygems'
require "dnssd"
require 'ruby-growl'

Thread.abort_on_exception = true

module Dejour
  KNOWN_SERVICES = Hash.new { |h,k|
    h[k] = lambda { |reply, rr|
      [k, k]
    }
  }
  KNOWN_SERVICES['git'] = lambda { |reply, rr|
    [ "git repository", "git clone #{reply.name}" ]
  }
  KNOWN_SERVICES['pastejour'] = lambda { |reply, rr|
    (from, to) = *reply.name.split('-')
    ['pastejour', "Paste from #{from} to #{to}"]
  }

  NOTIFICATION_NAME = 'ruby-growl Notification'
  def self.find(*names)
    g = Growl.new('localhost', 'ruby-growl', [NOTIFICATION_NAME])
    seen_services = Hash.new { |h,k| h[k] = {} }
    mutex = Mutex.new
    services = names.map do |name|
      DNSSD.browse("_#{name}._tcp") do |reply|
        DNSSD.resolve(reply.name, reply.type, reply.domain) do |rr|
          mutex.synchronize {
            unless seen_services[name].key?(reply.name)
              seen_services[name][reply.name] = true
              g.notify( NOTIFICATION_NAME,
                       *KNOWN_SERVICES[name].call(reply, rr)
                      )
            end
          }
        end
      end
    end

    services.each { |s| s.instance_variable_get(:@thread).join }
  end
end
