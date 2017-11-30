require 'chef'
require 'chef/handler'
require 'net/http'
require 'json'

class Icinga2Reporting < Chef::Handler
  attr_writer :icinga2_host, :icinga2_port

  def initialize(options = {})
    @icinga2_host = options[:icinga2_host]
    @icinga2_port = options[:icinga2_port]
    @icinga2_api_user = options[:icinga2_user]
    @icinga2_api_pass = options[:icinga2_pass]
    @icinga2_service = options[:icinga2_service]
  end

  def report
    perf_data = [
      "total_resources=#{run_status.all_resources.length};;;",
      "updated_resources=#{run_status.updated_resources.length};;;",
      "elapsed_time=#{run_status.elapsed_time};;;",
    ]
    if run_status.success?
      status = '0'
      status_msg = 'Chef successfully ran'
    else
      status = '2'
      status_msg = "exception='#{run_status.exception}'"
    end

    uri = URI.parse("https://#{@icinga2_host}:#{@icinga2_port}/v1/actions/process-check-result?service=#{node['fqdn']}!#{@icinga2_service}")
    begin
      Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https', verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
        req = Net::HTTP::Post.new(uri)
        req['Accept'] = 'application/json'
        req.body = {
          'exit_status' => status,
          'plugin_output' => status_msg,
          'performance_data' => perf_data,
        }.to_json
        req.basic_auth(@icinga2_user, @icinga2_pass)
        http.request(req)
      end
    rescue => e
      Chef::Log.error("Error reporting to icinga2: #{e}")
    end
  end
end
