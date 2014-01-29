# Title: jsbin tag for Jekyll
# Author: Remy Sharp (@rem)
# Description:
#   Given a bin url, generates the embed code for jsbin with defined panels.
#   A bin url is either just the code: `abcefg` or you can include the revision
#   `abcefg/4` or you can point to latest: `abcefg/latest`
#
# Panels: html, javascript, css, console, live (default)
#
# Syntax: {% jsbin bin [panels] [height] [width] %}
#
# Examples:
#
# Input: {% jsbin exedab %}
# Output: <a class="jsbin-embed" href="http://jsbin.com/exedab/1/embed?live">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>
#
# Input: {% jsbin exedab javascript,html %}
# Output: <a class="jsbin-embed" href="http://jsbin.com/exedab/1/embed?javascript,html">JS Bin</a><script src="http://static.jsbin.com/js/embed.js"></script>
#
module Jekyll
  class JSBin < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      if /(?<jsbin>\S+\/?\d?)(?:\s+(?<sequence>[\w,]+))?(?:\s+(?<revision>\d+))?/ =~ markup
        @bin = jsbin
        @revision = revision || 1
        @sequence = (sequence unless sequence == 'all') || 'html,css,js,output'
      end
    end

    def render(context)
      if @bin
<<HTML
<a class="jsbin-embed" href="http://jsbin.com/#{@bin}/#{@revision}/embed?#{@sequence}">JS Bin</a>
<script src="http://static.jsbin.com/js/embed.js"></script> 
HTML
      else
        "Error processing input, expected syntax: {% jsbin bin [panels] %}"
      end
    end
  end
end

Liquid::Template.register_tag('jsbin', Jekyll::JSBin)