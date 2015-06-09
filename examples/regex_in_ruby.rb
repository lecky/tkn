# encoding: utf-8

center <<-EOS
  Regex In Ruby - Capture Groups

  Lecky Lao(@leckylao)

  RORO 09-06-2015
EOS

center <<-EOS
  Mongo BSON Injection: Ruby Regexps Strike Again

  Jun 4, 2015 • Egor Homakov (@homakov)

  Mongoid is an ODM(Object Document Mapper) Framework
  for MongoDB written in Ruby

  Mongoid uses more low-level adapter Moped which uses BSON-ruby

  the vulnerability is in legal? method of BSON::ObjectId
EOS

code <<-EOS
  # "\\nhi\\n" =~ /hi$/
  # "\\nhi\\n" =~ /hi\\Z/
  # "\\nhi\\n" =~ /hi\\z/

  # Vulnerable
  def legal?(string)
    # March 31 2013 to Apr 7 2013
    /\\A\\h{24}\\Z/ === string.to_s
    # currently it thinks Mongo is down and pings it 39 more times with intervals.
    # In other words it keeps the worker busy for 5 seconds and makes x40 requests to Mongo DB
    # One way or another, it is Denial of Service.

    # Apr 7 2013 till now
    string.to_s =~ /^[0-9a-f]{24}$/i ? true : false
    # he attacker can send any data to the socket with something like
    # _id=Any binary data\\naaaaaaaaaaaaaaaaaaaaaaaa\\nAny binary data
  end

  # Patch
  def ((defined?(Moped::BSON) ? Moped::BSON : BSON)::ObjectId).legal?(s)
    /\\A\\h{24}\\z/ === s.to_s
  end
EOS

section "----Capturing Groups----" do
  code <<-EOS
    # What's the difference?

    /sat (in)/.match("The cat sat in the hat")

    "The cat sat in the hat" =~ /sat (in)/
  EOS

  center <<-EOS
    The difference is

    The operator =~ returns the index

    of the first match (nil if no match)

    and stores the MatchData

    in the global variable $~

    The method match returns

    the MatchData itself (again, nil if no match)
  EOS
end

section "Grouping with reference" do
  code <<-EOS
    # What's the difference?

    /\\$(?<dollars>\\d+)\\.(?<cents>\\d+)/.match("$3.67")

    "$3.67" =~ /\\$(?<dollars>\\d+)\\.(?<cents>\\d+)/

    /\\$(?<dollars>\\d+)\\.(?<cents>\\d+)/ =~ "$3.67"
  EOS

  center <<-EOS
    The difference is

    When named capture groups are used with a literal regexp

    on the left-hand side of an expression and the =~ operator,

    the captured text is also assigned to local variables

    with corresponding names.
  EOS
end

section "----Backreferences----" do
  code <<-EOS
    # Is this correct?

    "The cat sat in the hat".gsub(/(.*)cat(.*)/, "\#{$1}black dog\#{$2}")

    "The cat sat in the hat".gsub(/(.*)cat(.*)/, "\\1black dog\\2")

    "The cat sat in the hat".gsub(/(.*)cat(.*)/, '\\1black dog\\2')

    "The cat sat in the hat".gsub(/(?<prefix>.*)cat(.*)/, '\\k<prefix>black dog\\2')\n

    "The cat sat in the hat".gsub(/(?<prefix>.*)cat(?<suffix>.*)/, '\\k<prefix>black dog\\k<suffix>')
  EOS

  center <<-EOS
    $1 and $2 only store after the execution, therefore
    DO NOT USE $1 AND $2 IN GSUB,
    and use \\1 and \\2 instead

    use '' instead of "" when using regex

    A regexp can't use named backreferences
    and numbered backreferences simultaneously.
  EOS
end

section "That's all, thanks!

slide: https://github.com/leckylao/tkn - examples/regex_in_ruby.rb

slides made using tkn(https://github.com/fxn/tkn)" do
end

__END__
