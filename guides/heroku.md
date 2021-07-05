# Deployment on Heroku

    heroku apps:create --stack=container --addons heroku-postgresql:standard-0 # THIS WILL COST MONEY
    heroku config:add SECRET_KEY_BASE={secret} HOST={app_name}.herokuapp.com
    heroku pg:wait
    heroku pg:credentials:create {database_name} --name message_store
    heroku addons:attach {database_name} --credential message_store -a {app_name}
    git push heroku HEAD:master
    heroku run /app/bin/db_demo
    heroku ps:scale worker=1