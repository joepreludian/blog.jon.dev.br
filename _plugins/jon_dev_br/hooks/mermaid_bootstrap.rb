# frozen_string_literal: true

module JonDevBr
  module Hooks
    # Injects the Mermaid loader into rendered documents that actually contain
    # a diagram, and nowhere else.
    #
    # A front-matter flag would be bookkeeping the author forgets; an
    # unconditional include would put a ~2.7MB dependency on every page. The
    # marker is the `data-mermaid` attribute emitted by the mermaid tag.
    module MermaidBootstrap
      MARKER = "data-mermaid"
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
        return output unless output.include?(MARKER)
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
            item.output = inject(item.output)
          end
        end
      end
    end
  end
end

JonDevBr::Hooks::MermaidBootstrap.install
