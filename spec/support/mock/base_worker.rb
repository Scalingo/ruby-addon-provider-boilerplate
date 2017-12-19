class BaseWorker
  class Producer
    attr_reader :messages

    def initialize opts
      @messages = []
      @topic = opts[:topic]
    end

    def write message
      @messages.push message
    end
  end

  $producers = {}

  def self.perform_in(duration, *args)
    self.add_message(self.nsq_topic.to_s, self.nsq_message_type, Time.now + duration, *args)
  end

  def self.perform_async(*args)
    self.add_message(self.nsq_topic.to_s, self.nsq_message_type, Time.now, *args)
  end

  def self.nsq_topic(topic = "default")
    @topic ||= topic
  end

  def self.with_nsq(with_nsq = true)
    @with_nsq = with_nsq
  end

  def self.with_nsq?
    return ENV["MESSAGING_BACKEND"] == "nsq" || @with_nsq
  end

  def self.nsq_message_type(type = nil)
    type = self.to_s.underscore if type.nil?
    @message_type ||= type
  end

  def self.add_message topic, type, date, *args
    if $producers[topic] == nil
      $producers[topic] ||= Producer.new(
        :topic => topic,
      )
    end

    $producers[topic].write(
      {type: type, date: date, payload: args}
    )
  end

  def self.topic_count topic
    return 0 if $producers[topic].nil?
    return $producers[topic].messages.count
  end

  def self.last_message_type topic
    return nil if $producers[topic].nil?
    return $producers[topic].messages.last[:type]
  end

  def self.messages topic
    return nil if $producers[topic].nil?
    return $producers[topic].messages
  end

  def self.last_message topic
    return nil if $producers[topic].nil?
    return $producers[topic].messages.last
  end

  def self.purge
    $producers = {}
  end
end

