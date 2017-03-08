redis_config = Rails.application.config_for('redis')

Redis.current =
  Redis.new(
    :host => redis_config['host'],
    :port => redis_config['port'],
    :db => redis_config['db'],
    :username => redis_config['username']
  )
