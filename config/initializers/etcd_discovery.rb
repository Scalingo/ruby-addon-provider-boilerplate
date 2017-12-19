EtcdDiscovery.configure do |config|
  uri = URI(ENV['ETCD_HOST'])
  config.host = uri.host
  config.port = uri.port
  if ENV.key? 'ETCD_CACERT'
    config.use_ssl = true
    config.cacert = File.join ENV['HOME'], ENV['ETCD_CACERT']
    config.ssl_key = File.join ENV['HOME'], ENV['ETCD_TLS_KEY']
    config.ssl_cert = File.join ENV['HOME'], ENV['ETCD_TLS_CERT']
  end
end

if !Rails.env.test?
  port = ENV.fetch('SERVICE_PORT', ENV.fetch('PORT', 80))
  http_protocol = if port.to_i == 443
                    'https'
                  else
                    'http'
                  end

  EtcdDiscovery.register 'docker-addon-service', {
    'name' => ENV.fetch('SERVICE_HOST', '172.17.0.1'),
    'ports' => {
      http_protocol => port
    },
    'public' => true,
    'critical' => false
  }
end
