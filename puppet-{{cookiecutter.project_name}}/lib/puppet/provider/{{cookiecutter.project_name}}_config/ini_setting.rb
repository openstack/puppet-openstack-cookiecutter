Puppet::Type.type(:{{cookiecutter.project_name}}_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/{{cookiecutter.project_name}}/{{cookiecutter.project_name}}.conf'
  end

end
