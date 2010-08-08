require 'escape_utils'

def Q(opts = nil, &blk)
  Q.new(opts, &blk).to_s
end

def QX(opts, &blk)
  Q(opts ? opts.merge(:xml_compat => true) : nil, &blk).to_s
end

class Q
  VALID_TAGS = %w(a abbr acronym address area b base bdo big blockquote body br button caption cite code col colgroup dd del dfn div dl dt em fieldset form h1 h2 h3 h4 h5 h6 head html hr i img input ins kbd label legend li link map meta noscript object ol optgroup option p param pre q samp script select small span strong style sub sup table tbody td textarea tfoot th thead title tr tt ul var article aside audio canvas command datalist details embed figcaption figure footer header hgroup keygen mark meter nav output progress rp rt ruby section source summary time video)
  def initialize(opts = nil, &block)
    @__xml_compat = opts && opts.key?(:xml) ? opts[:xml] : false
    @__indent = opts && opts.key?(:indent) ? opts[:indent] : false
    @__default_doctype = opts && opts.key?(:doctype) ? opts[:doctype] : (@__xml_compat ? :xhtml_11 : :html5)
    @__out = ''
    @__level = 0
    instance_eval(&block)
  end
  
  VALID_TAGS.each do |tag|
    module_eval "
    def _#{tag}(value = nil, opts = nil, &blk)
      _(#{tag.inspect}, value, opts, &blk)
    end
    "
  end
  
  def div(class_or_id, value = nil, opts = nil, &blk)
    attr_name, attr_val = case class_or_id[0]
    when ?.
      ['class', class_or_id[1, class_or_id.size - 1]]
    when ?#
      ['class', class_or_id[1, class_or_id.size - 1]]
    end
    _('div', value, opts ? {attr_name => attr_val}.merge(opts) : {attr_name => attr_val}, &blk)
  end

  def _doctype(type = @__default_doctype)
    @__out << case type
    when :html_401_strict       then '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">'
    when :html_401_transitional then '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
    when :html_401_frameset     then '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">'
    when :xhtml_10_strict       then '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'
    when :xhtml_10_transitional then '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
    when :xhtml_10_frameset     then '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">'
    when :xhtml_11              then '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">'
    when :xhtml_11_basic        then '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">'
    when :html5                 then '<!DOCTYPE HTML>'
    end
  end

  def _(tagname, value = nil, opts = nil, &blk)
    if @__indent and !@__level.zero?
      @__out << "\n"
      @__level.times {__(@__indent)}
    end
    if value.is_a?(Hash)
      opts = value
      value = nil
    end
    @__out << "<#{tagname}"
    if opts and !opts.empty?
      opts.each do |k,v|
        @__out << " #{EscapeUtils.escape_html(k.to_s)}=\"#{EscapeUtils.escape_html(v.to_s)}\""
      end
    end
    if blk or value
      @__out << '>'
      __(value) if value
      @__level += 1
      instance_eval(&blk) if blk
      @__level -= 1
      if @__indent && blk
        @__out << "\n"
        @__level.times {__(@__indent)}
      end
      @__out << "</#{tagname}>"
    else
      @__out << (@__xml_compat ? '/>' : '>')
    end
    self
  end

  def __no_escape(text)
    @__out << text
    self
  end

  def __(text)
    __no_escape EscapeUtils.escape_html(text)
    self
  end
  
  def to_s
    @__out
  end
end
