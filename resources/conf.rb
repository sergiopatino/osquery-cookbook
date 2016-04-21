property :osquery_conf, kind_of: String, name_property: true
property :schedule, kind_of: Hash, default: {}, required: true
property :packs, kind_of: Array, default: []
property :fim_paths, kind_of: Hash, default: {}

default_action :create

action :create do
  config_hash = {
    options: node['osquery']['options'],
    schedule: schedule
  }

  unless packs.empty?

    directory osquery_packs_path do
      action :create
      recursive true
      mode 0755
    end

    packs.each do |pack|
      cookbook_file "#{osquery_packs_path}/#{pack}.conf" do
        mode '0444'
        source "packs/#{pack}.conf"
        owner 'root'
        group osquery_file_group
        # TODO(jacknagz): source cookbook option
      end
    end

    packs_config = {}

    packs.each do |pack|
      packs_config[pack] = "#{osquery_packs_path}/#{pack}.conf"
    end

    config_hash[:packs] = packs_config
  end

  config_hash[:file_paths] = fim_paths unless fim_paths.empty?

  template osquery_conf do
    source 'osquery.conf.erb'
    mode '0444'
    owner 'root'
    group osquery_file_group
    variables(
      config: Chef::JSONCompat.to_json_pretty(config_hash)
    )
  end
end

action :delete do
  file '/etc/osquery/osquery.conf' do
    action :delete
  end

  directory osquery_packs_path do
    action :delete
    recursive true
  end
end
