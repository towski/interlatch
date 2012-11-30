require "interlatch/version"
require 'interlatch/rails'

module Interlatch
  extend self

  def caching_key(controller, action, id, tag)
    "interlatch:#{ENV['RAILS_ASSET_ID']}:#{controller}:#{action}:#{id || 'all'}:#{tag || 'untagged'}"
  end

  def dependency_key(dependency_class)
    "interlatch:#{dependency_class.to_s}"
  end

  module Rails
    class Railtie < ::Rails::Railtie
      config.before_initialize do
        (config.active_record.observers ||= []) << Interlatch::InvalidationObserver
      end
    end
  end
end
