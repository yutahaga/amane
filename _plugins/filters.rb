module MyLiquidFilters
  def description(input)
  	if input.index(/<!--\s*more\s*-->/i)
      input.split(/<!--\s*more\s*-->/i)[0]
    else
      input
    end
  end

  def has_description(input)
    input =~ /<!--\s*more\s*-->/i ? true : false
  end

  def more(input)
    if input.index(/<!--\s*more\s*-->/i)
      input.split(/<!--\s*more\s*-->/i)[1]
    else
      input
    end
  end

  def ordinal(input)
    num = input.to_i
    if (10...20) === num
      "#{num}th"
    else
      g = %w{ th st nd rd th th th th th th }
      a = num.to_s
      c=a[-1..-1].to_i
      a + g[c]
    end
  end

  def regex_replace(input, string, replacement = '')
    input.to_s.gsub(Regexp.new(string.to_s), replacement.to_s)
  end

  def regex_replace_first(input, string, replacement = '')
    input.to_s.sub(Regexp.new(string.to_s), replacement.to_s)
  end

  def regex_remove(input, string)
    input.to_s.gsub(Regexp.new(string.to_s), '')
  end

  def regex_remove_first(input, string)
    input.to_s.sub(Regexp.new(string.to_s), '')
  end
end

Liquid::Template.register_filter(MyLiquidFilters)