class HealthController < ActionController::Base
  def show
    health_status = check_system_health

    if health_status[:status] == 'ok'
      render json: health_status, status: :ok
    else
      render json: health_status, status: :service_unavailable
    end
  end

  private

  def check_system_health
    status = {
      status: 'ok',
      timestamp: Time.current.iso8601,
      checks: {}
    }

    # Database check
    begin
      ActiveRecord::Base.connection.execute("SELECT 1")
      status[:checks][:database] = 'ok'
    rescue => e
      status[:status] = 'error'
      status[:checks][:database] = "error: #{e.message}"
    end

    # Memory check
    begin
      memory_info = get_memory_usage
      status[:checks][:memory] = memory_info
      if memory_info[:used_percentage] > 90
        status[:status] = 'warning'
      end
    rescue => e
      status[:checks][:memory] = "error: #{e.message}"
    end

    # CPU load check
    begin
      load_avg = get_load_average
      status[:checks][:load_average] = load_avg
      if load_avg > 2.0
        status[:status] = 'warning'
      end
    rescue => e
      status[:checks][:load_average] = "error: #{e.message}"
    end

    status
  end

  def get_memory_usage
    if File.exist?('/proc/meminfo')
      meminfo = File.read('/proc/meminfo')
      total = meminfo.match(/MemTotal:\s+(\d+)\s+kB/)[1].to_i
      available = meminfo.match(/MemAvailable:\s+(\d+)\s+kB/)[1].to_i
      used = total - available
      used_percentage = (used.to_f / total * 100).round(2)

      {
        total_kb: total,
        used_kb: used,
        available_kb: available,
        used_percentage: used_percentage
      }
    else
      { status: 'unavailable' }
    end
  end

  def get_load_average
    if File.exist?('/proc/loadavg')
      File.read('/proc/loadavg').split.first.to_f
    else
      0.0
    end
  end
end