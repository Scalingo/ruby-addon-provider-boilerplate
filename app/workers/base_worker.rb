class BaseWorker
  def self.perform_async(*args)
    NsqMessagingService.add_message(
      self.nsq_topic.to_s, self.nsq_message_type, *args,
    )
  end

  def self.perform_in(delay, *args)
    NsqMessagingService.add_deferred_message(
      self.nsq_topic.to_s, self.nsq_message_type, delay, *args,
    )
  end

  def self.perform_at(time, *args)
    self.perform_at(time.to_i - Time.now.to_i, *args)
  end

  def self.nsq_topic(topic = "default")
    @topic ||= topic
  end

  def self.nsq_message_type(type = nil)
    type = self.to_s.underscore if type.nil?
    @message_type ||= type
  end
end

