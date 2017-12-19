class BaseConsumer

  # https://github.com/nsqio/nsq/blob/73cb4384556d670446da8d9a3fe0117d19b41f17/nsqd/options.go#L113
  # DPUB uses requeuing process which has a limit of 1 hour by default
  # ```
  # MaxReqTimeout: 1 * time.Hour,
  # ```
  MAX_POSTPONE_DELAY = (ENV["NSQ_MAX_POSTPONE_DELAY"] || 3600).to_i

  class UnhandledMessageTypeError < RuntimeError
    def initialize(type)
      @type = type
    end

    def message
      "unhandled message type '#{@type}'"
    end
  end

  def terminate
    @consumer.terminate
  end

  def run
    loop do
      begin
        msg = @consumer.pop
        body = JSON.parse(msg.body)

        # Handle deferred messages
        if body["at"]
          delay = body["at"] - Time.now.to_i
          if delay > 0
            postpone_message msg, body, delay
            next
          end
        end

        Rails.logger.info "[nsqworker] #{@consumer.topic} - #{msg.id} - starting #{body["type"]} #{body["payload"]}"

        before = Time.now
        handle_message body
        after = Time.now

        if msg and msg.id
          Rails.logger.info "[nsqworker] #{@consumer.topic} - #{msg.id} - done     #{body["type"]} #{body["payload"]} - #{after - before}s"
          msg.finish
        else
          Rails.logger.info "[nsqworker] #{@consumer.topic} - terminated"
        end
      rescue UnhandledMessageTypeError => e
        msg.finish
        Rails.logger.info "[nsqworker] #{e.message}"
      rescue => e
        msg.finish
        Rails.logger.error "#{e.message} - #{e.class} - #{e.backtrace.join("\n")}"
        Rollbar.error e
      end
    end
  end

  def handle_message msg
    begin
      clazz = msg["type"].camelcase.constantize
    rescue NameError => e
      raise UnhandledMessageTypeError.new msg["type"]
    end

    if msg["payload"].is_a? Hash
      clazz.new.perform msg["payload"]
    else
      clazz.new.perform *msg["payload"]
    end
  end

  def postpone_message msg, body, delay
    delay = MAX_POSTPONE_DELAY if delay > MAX_POSTPONE_DELAY
    NsqMessagingService.get_producer(@consumer.topic).deferred_write(delay, msg.body)
    Rails.logger.info "[nsqworker] #{@consumer.topic} - #{msg.id} - postpone #{delay}s     #{body["type"]} #{body["payload"]}"
    msg.finish
  end
end

