# frozen_string_literal: true

require "rouge"
require_relative "base"

module JonDevBr
  module Tags
    # A terminal panel with a filename/language bar and Rouge highlighting.
    #
    #   {% codeblock lang="python" title="watchdog.py" %}
    #   def check(host): ...
    #   {% endcodeblock %}
    #
    # This tag exists because Kramdown fences cannot carry a title. Plain
    # fences still work and get the same terminal surface without the bar.
    #
    # An unknown language warns and falls back to plain text: unlike a
    # mistyped callout level, the failure mode is cosmetic and should not
    # block publishing.
    class CodeBlock < Base
      required :lang
      optional :title

      private

      def render_html(body, _context)
        <<~HTML
          <figure class="ds-code">
            <div class="ds-code__bar">#{bar}</div>
            <pre><code>#{highlight(body)}</code></pre>
          </figure>
        HTML
      end

      def bar
        parts = []
        parts << %(<span class="ds-code__title">#{attribute(:title)}</span>) if attribute(:title)
        parts << %(<span class="ds-code__lang">#{attribute(:lang)}</span>)
        parts.join
      end

      def highlight(body)
        Rouge::Formatters::HTML.new.format(lexer.lex(body))
      end

      def lexer
        @lexer ||= Rouge::Lexer.find_fancy(attribute(:lang)) || fallback_lexer
      end

      def fallback_lexer
        Jekyll.logger.warn(
          "codeblock:",
          "unknown language #{attribute(:lang).inspect}; falling back to plain text"
        )
        Rouge::Lexers::PlainText.new
      end
    end
  end
end

Liquid::Template.register_tag("codeblock", JonDevBr::Tags::CodeBlock)
