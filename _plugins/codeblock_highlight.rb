module Jekyll
  module Convertible
    alias :origin_render_liquid :render_liquid
    def render_liquid(content, payload, info)
      content.gsub!(/(?:^|\n)```(\w*)\n(.*?\n)```\n/m) do |text|
        $1.empty? ? text : "\n{% highlight #{$1} %}\n#{$2}{% endhighlight %}"
      end
      origin_render_liquid(content, payload, info)
    end
  end
end