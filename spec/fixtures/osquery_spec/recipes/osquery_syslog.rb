node.default['osquery']['syslog']['enabled'] = true
node.default['osquery']['syslog']['filename'] = '/etc/rsyslog.d/osquery.conf'
node.default['osquery']['syslog']['pipe_user'] = 'root'
node.default['osquery']['syslog']['pipe_group'] = 'root'
node.default['osquery']['syslog']['selector'] = 'daemon,cron.*'
node.default['osquery']['options']['syslog_pipe_path'] = '/var/osquery/syslog_pipe_test'

osquery_syslog node['osquery']['syslog']['filename'] do
  action :create
  only_if { node['osquery']['syslog']['enabled'] }
  notifies :restart, "service[#{osquery_daemon}]"
end

service osquery_daemon do
  action :nothing
end
