#!/usr/bin/env ruby

require ::File.expand_path('../../config/environment',  __FILE__)

require "logger"
require "nsq-env"

Nsq.logger = Logger.new(STDOUT)
Nsq.logger.level = Logger::INFO

workers = []

workers << Irma::Consumer.new

workers.each do |worker|
  Thread.new do
    begin
      Rails.logger.info "Start #{worker.class.to_s}"
      worker.run
    rescue Exception => ex
      Rails.logger.error "Error running consumer #{worker.class.to_s}: #{ex.class} #{ex} #{ex.backtrace.join("\n")}"
      raise ex
    end
  end
end

read, write = IO.pipe

trap(:INT) do
  write.puts
end

trap(:TERM) do
  write.puts
end

IO.select([read])

workers.each do |worker|
  worker.terminate
end

Rails.logger.info "consumers have stopped, exiting..."

