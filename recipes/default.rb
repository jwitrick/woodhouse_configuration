#
# Cookbook Name:: woodhouse_configuration
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

jen_dir = node['woodhouse']['jenkins_dir']
jen_file = node['woodhouse']['jenkins_file']
file_name = "#{jen_dir}/#{jen_file}"
dir_name = "#{jen_dir}/#{node['woodhouse']['cookbook_dir']}"

if ::File.exist?(file_name)

  new_orgs = node['woodhouse']['conf']['orgs'].dup
  File.open(file_name, 'r').each do |line|
    cookbook_name, github, _junk = line.split(' = ')
    github = github.sub('http://', '').sub('https://', '')
    github = github.sub('git://', '').sub('git@', '')
    github = github.split("/#{cookbook_name}")[0]

    if github.include? ':'
      org = github.split(':')[1]
    else
      org = github.split('/')[1]
    end
    if new_orgs.keys.include? org
      org_repos = new_orgs[org]
    else
      org_repos = []
    end
    org_repos.push(cookbook_name)
    org_repos = org_repos.uniq
    new_orgs[org] = org_repos
  end
  node.set['woodhouse']['conf']['orgs'] = new_orgs

  template "#{dir_name}/solo_run.json" do
    source 'solo_run.json.erb'
    variables(orgs: new_orgs)
  end

  template "#{dir_name}/woodhouse.conf" do
    source 'woodhouse.conf.erb'
    variables(orgs: new_orgs)
  end

  file file_name do
    action :delete
  end
end
