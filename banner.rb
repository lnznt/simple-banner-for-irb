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
    :MOVE      => proc {|l,c| "\e[#{l};#{c}H" },
    :SAVE      => "\e[s",
    :UNDO      => "\e[u",
  } : Hash.new("")

  color = RUBY_VERSION >= '2.0' ? e[:BLUE ] :
          RUBY_VERSION >= '1.9' ? e[:RED  ] :
          RUBY_VERSION >= '1.8' ? e[:GREEN] : e[:YELLOW]

  banner = e[:BOLD] + color + banner + e[:RESET]

  descr = <<-DESCR

  #{RUBY_DESCRIPTION.sub(/^ruby \S+/){ e[:BOLD] + color + $& + e[:RESET] }}
  #{RUBY_COPYRIGHT}

  DESCR


  unless $stdout.isatty
    puts banner
    puts descr
  else
    lines    = banner.split($/)
    height   = lines.length
    pos      = proc {|d| e[:MOVE][height + d, indent=4] }
    interval = proc { sleep 0.05 }

    (0...height).each do |n|
      puts e[:CLS] + pos[+1] + descr

      (0..n).each {|i| puts pos[i - n] + lines[i] }

      interval.call
    end

    puts pos[descr.split($/).length + 1] + e[:RESET]
  end
end

# vim:set ts=2 sw=2 et fenc=UTF-8:
