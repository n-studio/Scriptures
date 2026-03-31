require "net/http"
require "json"

module Llm
  class Openai < Base
    MODEL = "gpt-4o"

    def call(prompt)
      key = Rails.configuration.x.openai_api_key
      return nil unless key

      uri = URI("https://api.openai.com/v1/chat/completions")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{key}"
      request.body = {
        model: MODEL,
        max_tokens: 1024,
        messages: [ { role: "user", content: prompt } ]
      }.to_json

      response = http.request(request)
      return nil unless response.is_a?(Net::HTTPSuccess)

      data = JSON.parse(response.body)
      data.dig("choices", 0, "message", "content")&.strip
    end
  end
end
