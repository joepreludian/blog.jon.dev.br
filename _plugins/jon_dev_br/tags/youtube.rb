# frozen_string_literal: true

require_relative "base"

module JonDevBr
  module Tags
    # A framed 16:9 video embed with a mono caption.
    #
    #   {% youtube id="aqz-KE-bpKQ" caption="demo — sequencer v0.2" %}{% endyoutube %}
    #
    # youtube-nocookie so a visitor reading about a step sequencer does not
    # pick up tracking cookies on the way.
    class Youtube < Base
      required :id
      optional :caption

      EMBED_HOST = "https://www.youtube-nocookie.com/embed"
      WATCH_URL = "https://www.youtube.com/watch?v="
      ALLOW = "accelerometer; autoplay; clipboard-write; encrypted-media; " \
              "gyroscope; picture-in-picture"

      private

      def render_html(_body, _context)
        <<~HTML
          <figure class="ds-embed">
            <div class="ds-embed__frame">
              <iframe src="#{EMBED_HOST}/#{attribute(:id)}"
                      title="#{attribute(:caption)}"
                      loading="lazy"
                      allow="#{ALLOW}"
                      allowfullscreen></iframe>
            </div>
            <figcaption class="ds-embed__cap">
              <span>#{attribute(:caption)}</span>
              <a class="ds-embed__meta" href="#{WATCH_URL}#{attribute(:id)}"
                 rel="noreferrer noopener">youtube ↗</a>
            </figcaption>
          </figure>
        HTML
      end
    end
  end
end

Liquid::Template.register_tag("youtube", JonDevBr::Tags::Youtube)
