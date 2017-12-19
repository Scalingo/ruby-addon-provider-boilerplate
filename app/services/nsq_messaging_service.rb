require "nsq-env"

class NsqMessagingService
  $producers = {}

  def self.add_message topic, type, *args
    producer = self.get_producer topic
    args = args[0] if args.length == 1

    producer.write(
      {type: type, payload: args}.to_json
    )
  end

  def self.add_deferred_message topic, type, delay, *args
    producer = self.get_producer topic
    args = args[0] if args.length == 1

    at = Time.now.to_i + delay
    producer.write(
      {at: at, type: type, payload: args}.to_json
    )
  end

  def self.get_producer topic
    if $producers[topic] == nil
      $producers[topic] ||= NsqEnv::Producer.new(
        :topic => topic,
      )
      count = 0
      while !$producers[topic].connected? do
        count += 1
        Rails.logger.info "Waiting NSQ Producer #{topic}... #{count * 0.1}s"
        sleep count * 0.1
        if count == 10
          Rails.logger.error "Waiting NSQ Producer #{topic} unusually long..."
          Rollbar.error Exception.new("producer #{topic} doesn't get ready")
        end
      end
    end
    $producers[topic]
  end
end

