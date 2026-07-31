# frozen_string_literal: true

module JonDevBr
  module Filters
    # Turns rendered content into a whole-minute reading estimate.
    # Registered as the Liquid filter `reading_time`.
    module ReadingTime
      DEFAULT_WORDS_PER_MINUTE = 200
      TAG_PATTERN = /<[^>]*>/

      def reading_time(input)
        minutes = (word_count(input) / words_per_minute.to_f).ceil
        [minutes, 1].max
      end

      private

      def word_count(input)
        input.to_s.gsub(TAG_PATTERN, " ").split.size
      end

      def words_per_minute
        site = @context.registers[:site]
        rate = site&.config&.fetch("words_per_minute", nil)
        rate.to_i.positive? ? rate.to_i : DEFAULT_WORDS_PER_MINUTE
      end
    end
  end
end

Liquid::Template.register_filter(JonDevBr::Filters::ReadingTime)
