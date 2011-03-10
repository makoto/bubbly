APP_ROOT = File.join(File.dirname(__FILE__), '../')
APP_NAME = "test"
COMMAND  = "ruby #{APP_NAME}.rb mwc11"

def apply_defaults(w)
  w.interval = 5.seconds

  w.start_grace = 5.seconds
  w.stop_grace = 5.seconds
  w.restart_grace = 5.seconds

  # clean pid files before start if necessary
  w.behavior(:clean_pid_file)

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_exits)
  end

  # restart if memory or cpu is too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.interval = 20
      c.above = 200.megabytes
      c.times = [3, 5]
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end

God.watch do |w|
  port = 8123
  name = "#{APP_NAME}_#{port}"
  w.log =  File.join(APP_ROOT, "log/#{name}.log")
  w.name = name
  w.dir = APP_ROOT
  w.start = COMMAND
  apply_defaults(w)
end