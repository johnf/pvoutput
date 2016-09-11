require 'spec_helper'

require 'webmock/rspec'
require 'timecop'

require 'pvoutput/client'

# rubocop:disable RSpec/FilePath
describe PVOutput::Client do
  describe 'API' do
    let(:system_id) { '1234' }
    let(:api_key) { 'secret' }
    let(:client) { described_class.new(system_id, api_key) }
    let(:headers) do
      {
        'X-Pvoutput-Apikey'   => 'secret',
        'X-Pvoutput-Systemid' => '1234',
      }
    end

    before do
      Timecop.freeze(Time.local(2015))
    end

    after do
      Timecop.return
    end

    it 'adds a status' do
      body = 'd=20150101&t=00%3A00&v1=100&v2=50&v5=30&v6=200'
      st = stub_request(:post, 'http://pvoutput.org/service/r2/addstatus.jsp').with(:body => body, :headers => headers)

      client.add_status(
        :energy_generated => 100,
        :power_generated  => 50,
        :temperature      => 30,
        :voltage          => 200
      )

      expect(st).to have_been_requested
    end

    it 'adds an output' do
      body = 'd=2015-01-01&g=100&pp=50&tx=45&cm=moo'
      st = stub_request(:post, 'http://pvoutput.org/service/r2/addoutput.jsp').with(:body => body, :headers => headers)

      client.add_output(
        :output_date      => Date.today,
        :energy_generated => 100,
        :peak_power       => 50,
        :max_temp         => 45,
        :comments         => 'moo'
      )

      expect(st).to have_been_requested
    end

    it 'adds a batch output output' do
      body = 'data=20150101%2C1239%2C%2C%2C%2C%2C%2C%2C%2C%2C%2C%2C%3B20150102%2C1523%2C%2C%2C%2C%2C%2C%2C%2C%2C%2C%2C'
      st = stub_request(:post, 'http://pvoutput.org/service/r2/addbatchoutput.jsp').with(
        :body => body, :headers => headers
      )

      client.add_batch_output(
        :'20150101' => {
          :energy_generated => 1239,
        },
        :'20150102' => {
          :energy_generated => 1523,
        }
      )

      expect(st).to have_been_requested
    end

    it 'adds a batch output output with loading delay' do
      body = 'data=20150101%2C1239%2C%2C%2C%2C%2C%2C%2C%2C%2C%2C%2C%3B20150102%2C1523%2C%2C%2C%2C%2C%2C%2C%2C%2C%2C%2C'
      st = stub_request(:post, 'http://pvoutput.org/service/r2/addbatchoutput.jsp').with(
        :body => body, :headers => headers
      ).to_return(:body => 'Load in progress', :status => 400).then.to_return(:status => 200)

      client.add_batch_output(
        :'20150101' => {
          :energy_generated => 1239,
        },
        :'20150102' => {
          :energy_generated => 1523,
        }
      )

      expect(st).to have_been_requested.twice
    end
  end
end
# rubocop:enable RSpec/FilePath
