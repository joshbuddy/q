require File.join(File.dirname(__FILE__),'teststrap')

context "Q" do

  context "generating div" do
    setup { Q{_div{}} }
    asserts_topic.equals("<div></div>")
  end

  context "generating div with contents" do
    setup { Q{_div{ __"<this is contents>"}} }
    asserts_topic.equals("<div>&lt;this is contents&gt;</div>")
  end

  context "generating div with non-escaped contents" do
    setup { Q{_div{ __no_escape"<this is contents>"}} }
    asserts_topic.equals("<div><this is contents></div>")
  end

  context "generating nested HTML" do
    setup { Q{_div{ _span{__'this is awesome'}}} }
    asserts_topic.equals("<div><span>this is awesome</span></div>")
  end

  context "generating with indent" do
    setup { Q(:indent => ' '){_div{ _span{__'this is awesome'}}} }
    asserts_topic.equals("<div>\n <span>this is awesome\n </span>\n</div>")
  end

  context "generating divs with attrs" do
    setup { Q{_div(:id => '"this is my attribute"'){ __"<this is contents>"}} }
    asserts_topic.equals("<div id=\"&quot;this is my attribute&quot;\">&lt;this is contents&gt;</div>")
  end
end
