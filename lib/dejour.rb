$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require "dnssd"
require 'meow'

Thread.abort_on_exception = true

module Dejour
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

  def self.find(*names)
    g = Meow.new('dejour')
    seen_services = Hash.new { |h,k| h[k] = {} }
    mutex = Mutex.new
    seen_error_msg = false
    services = names.map do |name|
      DNSSD.browse("_#{name}._tcp") do |reply|
        DNSSD.resolve(reply.name, reply.type, reply.domain) do |rr|
          mutex.synchronize {
            unless seen_services[name].key?(reply.name)
              seen_services[name][reply.name] = true
              g.notify(*KNOWN_SERVICES[name].call(reply, rr))
            end
          }
        end
      end
    end

    services.each { |s| s.instance_variable_get(:@thread).join }
  end
end
