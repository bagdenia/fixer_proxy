class GetRates
  def initialize(params)
    @params = params
  end

  def call
    entry = Rate.find_by(params)
    return success_response(entry) if entry.present?

    res = FixerRequest.new(params).call

    return failure_response(res.body) unless res.success

    create_rate_response(res)
  end

  private

  attr_accessor :params

  def create_rate_response(res)
    rate = parse_rate(res)
    entry = Rate.create(params.merge(rate: rate))
    if entry.valid?
      success_response(entry)
    else
      failure_response(entry.errors.messages)
    end
  end

  def parse_rate(res)
    other = params['other']
    res.body.dig('rates', other)
  end

  def success_response(entry)
    OpenStruct.new(
      entry: entry,
      success: true
    )
  end

  def failure_response(params)
    OpenStruct.new(
      body: params,
      success: false
    )
  end
end
