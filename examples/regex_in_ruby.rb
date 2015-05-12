# encoding: utf-8

center <<-EOS
  Regex In Ruby - Capture Groups

  Lecky Lao(@leckylao)

  RORO 12-05-2015
EOS

section "----Capturing Groups----" do
  code <<-EOS
    /sat (in)/.match("The cat sat in the hat")

    "The cat sat in the hat" =~ /sat (in)/
  EOS

  center <<-EOS
    The operator =~ returns the index of the first match (nil if no match)
    and stores the MatchData in the global variable $~

    The method match returns the MatchData itself (again, nil if no match)
  EOS
end

section "Grouping with reference" do
  code <<-EOS
    /\\$(?<dollars>\\d+)\\.(?<cents>\\d+)/.match("$3.67")

    "$3.67" =~ /\\$(?<dollars>\\d+)\\.(?<cents>\\d+)/

    /\\$(?<dollars>\\d+)\\.(?<cents>\\d+)/ =~ "$3.67"
  EOS

  center <<-EOS
    When named capture groups are used with a literal regexp

    on the left-hand side of an expression and the =~ operator,

    the captured text is also assigned to local variables

    with corresponding names.
  EOS
end

section "----Backreferences----" do
  code <<-EOS
    "The cat sat in the hat".gsub(/(.*)cat(.*)/, "\#{$1}black dog\#{$2}")

    "The cat sat in the hat".gsub(/(.*)cat(.*)/, "\\1black dog\\2")

    "The cat sat in the hat".gsub(/(.*)cat(.*)/, '\\1black dog\\2')

    "The cat sat in the hat".gsub(/(?<prefix>.*)cat(.*)/, '\\k<prefix>black dog\\2')

    "The cat sat in the hat".gsub(/(?<prefix>.*)cat(?<suffix>.*)/, '\\k<prefix>black dog\\k<suffix>')
  EOS

  center <<-EOS
      $1 and $2 only store after the execution

      A regexp can't use named backreferences
      and numbered backreferences simultaneously.
  EOS
end

section "That's all, thanks!

slide: https://github.com/leckylao/tkn/blob/develop/examples/regex_in_ruby.rb

slides made using tkn(https://github.com/fxn/tkn)" do
end

__END__
