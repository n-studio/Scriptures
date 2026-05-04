class RobotsController < ApplicationController
  def show
    body =
      if Rails.env.production?
        "User-agent: *\nAllow: /\n"
      else
        "User-agent: *\nDisallow: /\n"
      end
    render plain: body, content_type: "text/plain"
  end
end
