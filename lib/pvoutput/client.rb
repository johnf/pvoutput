require 'httparty'

module PVOutput
  class Client
    include HTTParty
    base_uri 'pvoutput.org'
    # debug_output $stdout

    def initialize(system_id, api_key, donation_mode = false)
      @system_id = system_id.to_s
      @api_key = api_key.to_s
      # The batch operations have default limit of 30 sets of data in one request, when you
      # are using the donation mode the limit is 100 sets
      @batch_size = 30
      @batch_size = 100 if donation_mode

      self.class.headers 'X-Pvoutput-Apikey' => @api_key, 'X-Pvoutput-SystemId' => @system_id
    end

    # Helper method to post batch request to pvoutput that retries at the moment we get
    # a 400 error back with body containing 'Load in progress'
    def post_request(path, options = {}, &block)
      loop do
        response = self.class.post(path, options, &block)

        if response.code == 400 && response.body =~ /Load in progress/
          # We can't send data too fast, when the previous request is still loaded we
          # have to wait so sleep 10 seconds and try again
          sleep(10)
        elsif response.code == 200
          return
        else
          raise("Bad Post: #{response.body}")
        end
      end
    end

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def add_status(options)
      time = options[:when] || Time.now

      params = {
        'd' => time.strftime('%Y%m%d'),
        't' => time.strftime('%H:%M'),
      }

      params[:v1] = options[:energy_generated] if options[:energy_generated]
      params[:v2] = options[:power_generated] if options[:power_generated]
      params[:v3] = options[:energy_consumed] if options[:energy_consumed]
      params[:v4] = options[:power_consumed] if options[:power_consumed]
      params[:v5] = options[:temperature] if options[:temperature]
      params[:v6] = options[:voltage] if options[:voltage]
      params[:c1] = 1 if options[:cumulative] == true
      params[:n]  = 1 if options[:net] == true

      response = self.class.post('/service/r2/addstatus.jsp', :body => params)

      raise('Bad Post') unless response.code == 200
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def add_output(options)
      params = {
      }

      params[:d] = options[:output_date]
      params[:g] = options[:energy_generated] if options[:energy_generated]
      params[:pp] = options[:peak_power] if options[:peak_power]
      params[:pt] = options[:peak_time] if options[:peak_time]
      params[:cd] = options[:condition] if options[:condition]
      params[:tm] = options[:min_temp] if options[:min_temp]
      params[:tx] = options[:max_temp] if options[:max_temp]
      params[:cm] = options[:comments] if options[:comments]
      params[:ip] = options[:import_peak] if options[:import_peak]
      params[:io] = options[:import_off_peak] if options[:import_off_peak]
      params[:is] = options[:import_shoulder] if options[:import_shoulder]
      params[:ih] = options[:import_high_shoulder] if options[:import_high_shoulder]
      params[:c] = options[:consumption] if options[:consumption]

      response = self.class.post('/service/r2/addoutput.jsp', :body => params)

      raise('Bad Post') unless response.code == 200
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    # rubocop:disable Metrics/AbcSize
    def add_batch_output(options)
      keys = %i(energy_generated energy_export energy_used)
      keys += %i(peak_power peak_time condition min_temp)
      keys += %i(max_temp comments import_peak import_off_peak)
      keys += %i(import_shoulder)

      options.to_a.each_slice(@batch_size) do |slice|
        data = ''
        slice.each do |entry|
          date, values = entry
          data += "#{date}," + keys.map { |key| values[key] }.join(',') + ';'
        end

        params = {
          :data => data.chop,
        }

        post_request('/service/r2/addbatchoutput.jsp', :body => params)
      end
    end
    # rubocop:enable Metrics/AbcSize
  end
end
