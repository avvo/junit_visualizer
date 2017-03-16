PROJECT_NAMES = [
  'jake-avvo-acceptance-prod',
  'avvo_acceptance-social_login-stag'
]

BUILDS_TO_PULL=ENV.fetch("BUILDS_TO_PULL", 3).to_i
