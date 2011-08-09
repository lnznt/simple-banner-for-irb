#!/usr/bin/env ruby

instance_eval do
  banner = <<-BANNER

  ######  #     # ######  #     #
  #     # #     # #     #  #   #
  #     # #     # #     #   # #
  ######  #     # ######     #
  #   #   #     # #     #    #
  #    #  #     # #     #    #
  #     #  #####  ######     #

  BANNER

  e = $stdout.isatty ? {
    :BOLD      => "\e[1m",
    :UNDERLINE => "\e[4m",
    :REVERSE   => "\e[7m",
    :BLACK     => "\e[30m",
    :RED       => "\e[31m",
    :GREEN     => "\e[32m",
    :YELLOW    => "\e[33m",
    :BLUE      => "\e[34m",
    :MAGENTA   => "\e[35m",
    :CYAN      => "\e[36m",
    :WHITE     => "\e[37m",
    :RESET     => "\e[m",

    :CLS       => "\e[2J",
    :MOVE      => proc {|l,c| "\e[#{l||1};#{c||1}H" },
    :SAVE      => "\e[s",
    :UNDO      => "\e[u",
  } : Hash.new("")

  color = RUBY_VERSION >= '2.0' ? e[:BLUE ] :
          RUBY_VERSION >= '1.9' ? e[:RED  ] :
          RUBY_VERSION >= '1.8' ? e[:GREEN] : e[:YELLOW]

  banner = e[:BOLD] + color + banner + e[:RESET]

  descr = <<-DESCR

  #{RUBY_DESCRIPTION.sub(/^(ruby )(\S+)/){ $1 + e[:BOLD] + color + $2 + e[:RESET] }}
  #{RUBY_COPYRIGHT}

  DESCR


  unless $stdout.isatty
    puts banner
    puts descr
  else
    lines    = banner.split($/)
    indent   = 4
    pos      = proc {|n,i| e[:MOVE][lines.length - n + i, indent] }
    interval = 0.05


    (0...lines.length).each do |n|
      puts e[:CLS]
      puts e[:MOVE][lines.length, indent] + descr
      (0..n).each {|i| puts pos[n, i] + lines[i] }
      sleep interval
    end

    puts e[:MOVE][lines.length + descr.split($/).length, 1] + e[:RESET]
  end
end

# vim:set ts=2 sw=2 et fenc=UTF-8:
