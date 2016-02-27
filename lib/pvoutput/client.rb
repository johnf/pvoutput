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

      raise('Bad Post') unless response.code == 200
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
      params[:ip] = options[:import_peak] if options[:import_peak]
      params[:io] = options[:import_off_peak] if options[:import_off_peak]
      params[:is] = options[:import_shoulder] if options[:import_shoulder]
      params[:ih] = options[:import_high_shoulder] if options[:import_high_shoulder]
      params[:c] = options[:consumption] if options[:consumption]

      response = self.class.post('/service/r2/addoutput.jsp', :body => params)

      raise('Bad Post') unless response.code == 200
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    def add_batch_output(options)
      params = {
      }
      data = ''

      options.each do |date, values|
        data.concat "#{date},"
        data.concat values[:energy_generated].to_s
        data.concat ','
        data.concat values[:energy_export].to_s if values[:energy_export]
        data.concat ','
        data.concat values[:energy_used].to_s if values[:energy_used]
        data.concat ','
        data.concat values[:peak_power].to_s if values[:peak_power]
        data.concat ','
        data.concat values[:peak_time].to_s if values[:peak_time]
        data.concat ','
        data.concat values[:condition].to_s if values[:condition]
        data.concat ','
        data.concat values[:min_temp].to_s if values[:min_temp]
        data.concat ','
        data.concat values[:max_temp].to_s if values[:max_temp]
        data.concat ','
        data.concat values[:comments].to_s if values[:comments]
        data.concat ','
        data.concat values[:import_peak].to_s if values[:import_peak]
        data.concat ','
        data.concat values[:import_off_peak].to_s if values[:import_off_peak]
        data.concat ','
        data.concat values[:import_shoulder].to_s if values[:import_shoulder]
        data.concat ';'
      end

      params[:data] = data.chop

      response = self.class.post('/service/r2/addbatchoutput.jsp', :body => params)

      raise('Bad Post') unless response.code == 200
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
  end
end
