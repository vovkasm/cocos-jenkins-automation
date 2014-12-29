include_recipe 'windows'
include_recipe 'chocolatey'

chocolatey 'notepadplusplus'
chocolatey 'jdk8'
chocolatey 'visualstudiocommunity2013'
chocolatey 'git'
chocolatey 'python2'

windows_reboot 60 do
    reason 'chef said so'
    action :nothing
end

# cmake
dev_zip 'c:/cmake' do
    source 'http://www.cmake.org/files/v3.1/cmake-3.1.0-win32-x86.zip'
    action :unzip
    startLevel 1
    not_if {::File.exists?('c:/cmake/bin/cmake.exe')}
end
windows_path 'c:\cmake\bin' do
    action :add
    notifies :request, 'windows_reboot[60]'
end

# jenkins
jenkins_home = 'c:/jenkins'

directory jenkins_home do
    action :create
end

template "#{jenkins_home}/jenkins-slave.xml" do
    source "jenkins-slave.xml.erb"
    variables(:jenkins_home => jenkins_home,
              :jenkins_jar => "#{jenkins_home}/swarm-client.jar",
              :name => 'windows2012r2',
              :username => 'slave',
              :password => 'slave',
              :labels   => 'win msvc')
end

template "#{jenkins_home}/jenkins-slave.exe.config" do
    source "jenkins-slave.exe.config.erb"
end

remote_file "c:/jenkins/jenkins-slave.exe" do
    source "http://repo.jenkins-ci.org/releases/com/sun/winsw/winsw/1.16/winsw-1.16-bin.exe"
    action :create_if_missing
end

require 'win32/service'

execute "#{jenkins_home}/jenkins-slave.exe install" do
    cwd jenkins_home
    not_if { ::Win32::Service.exists?('jenkins-slave') }
end

service 'jenkins-slave' do
    action :nothing
end

remote_file "c:/jenkins/swarm-client.jar" do
    source "http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/1.22/swarm-client-1.22-jar-with-dependencies.jar"
    action :create_if_missing
    notifies :restart, resources(:service => 'jenkins-slave'), :immediately
end

service 'jenkins-slave' do
    action :start
end

