require "dummy_globalize/version"

if defined?(ActiveRecord::Base)
  require 'dummy_globalize/translates'
end

module DummyGlobalize
  class << self
    def with_locale(locale, &block)
      previous_locale = I18n.locale

      begin
        I18n.locale = locale
        result = yield(locale)
      ensure
        I18n.locale = previous_locale
      end

      result
    end
  end
end
