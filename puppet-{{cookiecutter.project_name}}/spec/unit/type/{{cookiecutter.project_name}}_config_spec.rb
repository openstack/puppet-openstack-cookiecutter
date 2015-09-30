require 'puppet'
require 'puppet/type/{{cookiecutter.project_name}}_config'
describe 'Puppet::Type.type(:{{cookiecutter.project_name}}_config)' do
  before :each do
    @{{cookiecutter.project_name}}_config = Puppet::Type.type(:{{cookiecutter.project_name}}_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should require a name' do
    expect {
      Puppet::Type.type(:{{cookiecutter.project_name}}_config).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:{{cookiecutter.project_name}}_config).new(:name => 'f oo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should fail when there is no section' do
    expect {
      Puppet::Type.type(:{{cookiecutter.project_name}}_config).new(:name => 'foo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should not require a value when ensure is absent' do
    Puppet::Type.type(:{{cookiecutter.project_name}}_config).new(:name => 'DEFAULT/foo', :ensure => :absent)
  end

  it 'should accept a valid value' do
    @{{cookiecutter.project_name}}_config[:value] = 'bar'
    expect(@{{cookiecutter.project_name}}_config[:value]).to eq('bar')
  end

  it 'should not accept a value with whitespace' do
    @{{cookiecutter.project_name}}_config[:value] = 'b ar'
    expect(@{{cookiecutter.project_name}}_config[:value]).to eq('b ar')
  end

  it 'should accept valid ensure values' do
    @{{cookiecutter.project_name}}_config[:ensure] = :present
    expect(@{{cookiecutter.project_name}}_config[:ensure]).to eq(:present)
    @{{cookiecutter.project_name}}_config[:ensure] = :absent
    expect(@{{cookiecutter.project_name}}_config[:ensure]).to eq(:absent)
  end

  it 'should not accept invalid ensure values' do
    expect {
      @{{cookiecutter.project_name}}_config[:ensure] = :latest
    }.to raise_error(Puppet::Error, /Invalid value/)
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    package = Puppet::Type.type(:package).new(:name => '{{cookiecutter.project_name}}-common')
    catalog.add_resource package, @{{cookiecutter.project_name}}_config
    dependency = @{{cookiecutter.project_name}}_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@{{cookiecutter.project_name}}_config)
    expect(dependency[0].source).to eq(package)
  end


end
