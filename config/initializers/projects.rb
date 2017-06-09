default_builds = Rails.env.development? ? 3 : 99999

BUILDS_TO_PULL = ENV.fetch("BUILDS_TO_PULL", default_builds).to_i

STATUS_SUCCESS = "SUCCESS"
STATUS_FAILURE = "FAILURE"
