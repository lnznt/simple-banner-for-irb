#!/usr/bin/env ruby

instance_eval do
  #
  # configuration
  #
  version_color = RUBY_VERSION >= '2.3' ? :YELLOW  :
                  RUBY_VERSION >= '2.2' ? :CYAN    :
                  RUBY_VERSION >= '2.1' ? :RED     :
                  RUBY_VERSION >= '2.0' ? :BLUE    :
                  RUBY_VERSION >= '1.9' ? :MAGENTA :
                  RUBY_VERSION >= '1.8' ? :GREEN   : false

  banner_type = :DEFAULT

  #
  # procedure
  #
  seq = proc {|n| $stdout.isatty ? "\e[#{n}m" : "" }

  color = proc do |s|
    n = {
      :BLACK    => 30,
      :RED      => 31,
      :GREEN    => 32,
      :YELLOW   => 33,
      :BLUE     => 34,
      :MAGENTA  => 35,
      :CYAN     => 36,
      :WHITE    => 37,
    }[version_color]

    "#{seq[n]}#{s}#{seq[0]}"
  end

  cls  = "\e[2J"
  move = proc {|y| "\e[#{y}H" }

  #
  # strings
  #
  banner1 = <<-'BANNER1'
      ######  #     # ######  #     #
      #     # #     # #     #  #   #
      #     # #     # #     #   # #
      ######  #     # ######     #
      #   #   #     # #     #    #
      #    #  #     # #     #    #
      #     #  #####  ######     #
  BANNER1

  banner2 =<<-'BANNER2'
    ____          __           
   |  _ \\ __  _ | ||_   __  __
   | |_) || ||| || '_ \\| ||| ||
   |  _ <<| ||| || |_) || |_| ||
   |_||\_\\\__,//|_.__// \__, ||
                         /___//
  BANNER2

  banner =  case banner_type
              when :FIGLET  ; banner2
              else          ; banner1
            end

  descr = <<-DESCR
  #{RUBY_DESCRIPTION.sub(/\Aruby \S+/){ color[$&] }}
  #{RUBY_COPYRIGHT}
  DESCR

  #
  # print banner
  #
  if $stdout.isatty
    lines = banner.split $/
    top = 2

    [*0...lines.size].reverse.each_with_index do |y, i|
      puts cls
      puts move[top + y             ] + color[lines[0..i] * $/]
      puts move[top + lines.size + 1] + descr
      puts

      sleep 0.1
    end

  else
    puts $/ + banner + $/ + descr + $/

  end
end

# vim:set ts=2 sw=2 et:
