module IrcMachine
  class Core < Plugin::Base

    def start
      session.user options.user, options.realname
      session.nick options.nick
      session.state.nick = options.nick
      options.channels.each { |c| session.join c } if options.channels
    end

    def receive_line(line)
      case line

      when /^PING (.*)/
        session.raw "PONG #{$1}"

      when /^:#{self_pattern} JOIN (\S+)/
        channels << $1
        puts "[core] channels: #{channels.join(", ")}"

      when /^:#{self_pattern} PART (\S+)/
        channels.delete $1
        puts "[core] channels: #{channels.join(", ")}"
      end
    end

    private

    def options
      session.options
    end

    def self_pattern
      Regexp.escape(session.state.nick) + '!\S+@\S+'
    end

    def channels
      session.state.channels
    end

  end
end