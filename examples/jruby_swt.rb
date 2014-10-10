# encoding: utf-8

center <<-EOS
  JRuby SWT Basic + EXE + Rails

  Lecky Lao(@leckylao)

  RORO 14-10-2014
EOS

section "JRuby SWT" do
  block <<-EOS
    SWT (https://github.com/danlucraft/swt)

    This gem contains everything required to write cross-platform desktop applications with JRuby and SWT.


    Features:
    *  Includes all the jar files needed.
    *  Selects and loads the correct SWT jar for the platform.
    *  Imports of many swt Java classes into a 1-1 mapped Ruby class hierarchy.
    *  Examples to get you started. (For more see this SWT cookbook)
  EOS
end

section "JRUBY SWT Cookbook" do
  block <<-EOS
    JRuby SWT Cookbook (https://github.com/danlucraft/jruby-swt-cookbook)

    JRuby and SWT is a great platform for writing cross-platform desktop applications. This repo contains 
    examples of how to get started.

    Why JRuby/SWT?
    --------------
    * Fast, compatible Ruby implementation.
    * JRuby and SWT are flawlessly cross-platform.
    * SWT has native widgets (for the most part).
    * SWT powers Eclipse, so there's nothing you need that it doesn't do.
    * You don't need to touch Java! Write everything in Ruby.
  EOS
end

section "JRuby SWT Basic" do
  center <<-EOS
    JRuby/SWT + Warbler + Launch4j = EXE
  EOS
end

section "Simple JRuby/SWT with Rails Integration" do
end

section "That's all, thanks!" do
  center <<-EOS
    JRuby SWT Basic + EXE + Rails

    slide using tkn(https://github.com/fxn/tkn) and on Github:
    https://github.com/leckylao/tkn/blob/develop/examples/jruby_swt.rb

    Lecky Lao(@leckylao)

    RORO 14-10-2014
  EOS
end

__END__
