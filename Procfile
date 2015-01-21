web: bundle exec puma -C config/puma.rb
worker: env TERM_CHILD=1 COUNT=${RESQUE_FORK_COUNT:-1} QUEUE=* bundle exec rake resque:workers
