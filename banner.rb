#!/usr/bin/env ruby

instance_eval do
  #
  # version color
  #
  version_color = RUBY_VERSION >= '2.1' ? :RED     :
                  RUBY_VERSION >= '2.0' ? :BLUE    :
                  RUBY_VERSION >= '1.9' ? :MAGENTA :
                  RUBY_VERSION >= '1.8' ? :GREEN   : :YELLOW

  #
  # escape sequence
  #
  e = Hash.new {|h,k| h[k] = k.to_s =~ /\A[[:lower:]]/ ? proc {""} : "" }
  e.merge!({
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
    :HOME      => "\e[H",
#    :move      => proc {|l,c| "\e[#{l};#{c}H" },
#    :save      => proc { "\e[s" },
#    :undo      => proc { "\e[u" },
  }) if $stdout.isatty

  color = proc {|s| e[:BOLD] + e[version_color] + s + e[:RESET] }

  #
  # strings
  #
  banner = <<-BANNER

      ######  #     # ######  #     #
      #     # #     # #     #  #   #
      #     # #     # #     #   # #
      ######  #     # ######     #
      #   #   #     # #     #    #
      #    #  #     # #     #    #
      #     #  #####  ######     #

  BANNER

  descr = <<-DESCR

  #{RUBY_DESCRIPTION.sub(/^ruby \S+/){ color[$&] }}
  #{RUBY_COPYRIGHT}

  DESCR

  #
  # print banner
  #
  unless $stdout.isatty
    puts banner + descr
  else
    height = banner.split($/).length
    blanks = ([$/] * height).join

    (0..height).each do |i|
      puts e[:CLS] + e[:HOME]
      puts color[ (blanks + banner).split($/)[i, height].join($/) ]
      puts descr

      sleep 0.1
    end
  end
end

# vim:set ts=2 sw=2 et fenc=UTF-8:
