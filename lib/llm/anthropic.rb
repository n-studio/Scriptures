require "net/http"
require "json"

module Llm
  class Anthropic < Base
    MODEL = "claude-sonnet-4-20250514"

    def call(prompt)
      key = Rails.configuration.x.anthropic_api_key
      return nil unless key

      uri = URI("https://api.anthropic.com/v1/messages")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request["x-api-key"] = key
      request["anthropic-version"] = "2023-06-01"
      request.body = {
        model: MODEL,
        max_tokens: 1024,
        messages: [ { role: "user", content: prompt } ]
      }.to_json

      response = http.request(request)
      return nil unless response.is_a?(Net::HTTPSuccess)

      data = JSON.parse(response.body)
      data.dig("content", 0, "text")&.strip
    end
  end
end
