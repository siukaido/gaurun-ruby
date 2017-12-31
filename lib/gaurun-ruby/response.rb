require 'json'

module Gaurun
  class Response
    def initialize(res)
      @res = res
    end

    def status_code
      @res.response_code.to_i
    end

    def status_message
      @res.return_code
    end

    def body
      return nil unless @res.response_body.length > 1
      JSON.parse(@res.response_body, { symbolize_names: true })
    end
  end
end
