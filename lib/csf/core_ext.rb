class Object
  def start_timers
    @timers_started = true
    @total_time = {}
  end
  def timer_trace(message="Unnamed Block")
    if block_given?
      begin
        start_time=Time.now if @timers_started
        yield
      ensure
        end_time=Time.now if @timers_started
        if @timers_started
          @total_time[message] = 0 unless @total_time.key?(message)
          @total_time[message] += (end_time - start_time)
        end
      end
    end
  end
  def stop_timers
    unless @timers_started
      return
    end
    entries = @total_time.entries
    entries.sort! do |e1,e2|
      e2[1] <=> e1[1]
    end
    entries.first(20).each do |e|
      puts "#{e[0]} => #{e[1]}"
    end
    @timers_started = false
    @total_time.clear
  end
end
