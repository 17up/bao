# coding: utf-8

require "open3"

module CmdHelper
  def cmd cmd
    logger "#{time_to_str}\tcmd:#{cmd}"
    _, stdout, stderr, _ = Open3.popen3 cmd
    stderr_str = stderr.read
    stdout_str = stdout.read
    logger "error:"
    logger stderr_str
    logger "output:"
    logger stdout_str
    logger "#{time_to_str}\tcmd:end"
    return stderr_str, stdout_str
  end

  def time_to_str time=Time.now
    time.strftime("%Y-%m-%d %H:%M:%S") unless time.nil?
  rescue => e
    time
  end

  def logger *args
    puts "#{time_to_str}\t#{args.join("\t")}"
  end

end