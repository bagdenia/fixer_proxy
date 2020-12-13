class FixerRequest
  def initialize(params)
    @date = params['date']
    @base = params['base']
    @other = params['other']
  end

  def call
    response = send_request
    format_response(response)
  end

  private

  attr_accessor :date, :base, :other

  def url
    "http://data.fixer.io/api/#{date}"
  end

  def access_key
    ENV['RATES_ACCESS_KEY'] || 'absent'
  end

  def send_request
    uri = URI(url)
    params = { symbols: other, base: base, access_key: access_key }
    uri.query = URI.encode_www_form(params)

    Net::HTTP.get_response(uri)
  end

  def format_response(response)
    body = JSON.parse(response.body)
    OpenStruct.new(
      success: body['success'],
      body: body
    )
  end
end
