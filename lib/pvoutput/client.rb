require 'httparty'

module PVOutput
  class Client
    include HTTParty
    base_uri 'pvoutput.org'
    # debug_output $stdout

    def initialize(system_id, api_key)
      @system_id = system_id.to_s
      @api_key = api_key.to_s

      self.class.headers 'X-Pvoutput-Apikey' => @api_key, 'X-Pvoutput-SystemId' => @system_id
    end

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
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

      fail('Bad Post') unless response.code == 200
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
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

      response = self.class.post('/service/r2/addoutput.jsp', :body => params)

      fail('Bad Post') unless response.code == 200
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
  end
end
