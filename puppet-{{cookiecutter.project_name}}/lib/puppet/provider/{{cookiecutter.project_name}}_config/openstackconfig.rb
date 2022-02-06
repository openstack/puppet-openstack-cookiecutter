Puppet::Type.type(:{{cookiecutter.project_name}}_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/{{cookiecutter.project_name}}/{{cookiecutter.project_name}}.conf'
  end

end
