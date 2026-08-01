# frozen_string_literal: true

module JonDevBr
  module Hooks
    # Injects the Mermaid loader into rendered documents that actually contain
    # a diagram, and nowhere else.
    #
    # A front-matter flag would be bookkeeping the author forgets; an
    # unconditional include would put a ~2.7MB dependency on every page. The
    # marker is the opening `<pre class="mermaid" data-mermaid>` tag emitted
    # by the mermaid Liquid tag — matched as a real tag, not a bare substring.
    #
    # Both Atom feeds embed `{{ post.content | strip_newlines | xml_escape }}`,
    # and `xml_escape` does not touch attribute *names* — only the surrounding
    # markup gets entity-escaped — so a naive substring marker like
    # `"data-mermaid"` would still match inside a feed, where there is no
    # `</body>` to insert before and the append fallback would tack raw
    # `<script>` tags on after `</feed>`, corrupting the XML. Belt-and-braces
    # against that: the hook only ever runs on `.html` output (checked via
    # `output_ext`, confirmed present on both `Jekyll::Page` and
    # `Jekyll::Document` in the pinned Jekyll 4.4.1), and the marker itself
    # requires the literal, unescaped `<pre ...>` tag, so even an `.html`
    # document could not match it once the content has gone through
    # `xml_escape` (which would turn the `"` and `<` into entities).
    #
    # The `(?:="")?` tolerates a quirk of the real pipeline: the mermaid tag
    # itself emits a bare boolean `data-mermaid` (no `="..."`), but Kramdown
    # parses that raw HTML block into its own element tree and re-serialises
    # it, and its HTML converter always writes a value — turning the boolean
    # attribute into `data-mermaid=""` by the time it reaches this hook.
    # Confirmed directly against the fixture's rendered post output.
    module MermaidBootstrap
      MARKER = /<pre class="mermaid" data-mermaid(?:="")?>/
      VERSION = "10.9.1"
      SRI = "sha384-WmdflGW9aGfoBdHc4rRyWzYuAjEmDwMdGdiPNacbwfGKxBW/SO6guzuQ76qjnSlr"

      # Theme variables carried over from the reference design, orange edition.
      THEME = <<~JS.strip
        {
          startOnLoad: true,
          theme: "base",
          fontFamily: '"IBM Plex Mono", monospace',
          themeVariables: {
            fontSize: "13px",
            primaryColor: "#fff4ec",
            primaryBorderColor: "#cbc2b2",
            primaryTextColor: "#211d18",
            lineColor: "#a84a05",
            secondaryColor: "#f7f4ee",
            tertiaryColor: "#ffffff",
            edgeLabelBackground: "#fdfcf9",
            clusterBkg: "#f7f4ee",
            nodeBorder: "#cbc2b2",
            mainBkg: "#fff4ec",
            textColor: "#554f47"
          }
        }
      JS

      def self.snippet
        <<~HTML
          <script src="https://cdn.jsdelivr.net/npm/mermaid@#{VERSION}/dist/mermaid.min.js"
                  integrity="#{SRI}" crossorigin="anonymous"></script>
          <script>mermaid.initialize(#{THEME});</script>
        HTML
      end

      # Inserts before </body> when a layout provided one; appends otherwise,
      # so layout-less documents (and the test fixtures) still work.
      def self.inject(output)
        return output unless output.match?(MARKER)
        return output if output.include?("mermaid.min.js")

        if output.include?("</body>")
          output.sub("</body>", "#{snippet}</body>")
        else
          output + snippet
        end
      end

      def self.install
        %i[documents pages].each do |owner|
          Jekyll::Hooks.register(owner, :post_render) do |item|
            next unless item.output_ext == ".html"

            item.output = inject(item.output)
          end
        end
      end
    end
  end
end

JonDevBr::Hooks::MermaidBootstrap.install
