# Define your sites in the 'sites' array.
# For example 'first-example.com' in the array will default to HTTPS port 443
# Or be explicit with the port like this: 'second-example.com:8443'

sites = [
  'chef.io',
  'id.chef.io',
  'habitat.sh',
  'docs.chef.io',
  'blog.chef.io',
  'learn.chef.io',
  'manage.chef.io',
  'bldr.habitat.sh',
  'automate.chef.io',
  'partners.chef.io',
  'training.chef.io',
  'packages.chef.io',
  'community.chef.io',
  'downloads.chef.io',
  'licensing.chef.io',
  'omnitruck.chef.io',
  'discourse.chef.io',
  'forums.habitat.sh',
  'supermarket.chef.io'
]

# ----------------------------------------------------------

# Instantiating `ssl_certificate` only once per site instead of once per control.
# This makes the profile more performant and will produce fewer ssl connections for the sites.
sites_resources = sites.map do |site|
  site_host, site_port = site.split(':')
  ssl_certificate( { host: site_host, port: site_port } )
end

control '01-ssl-exists' do
  impact 1
  title 'Check that all sites return an SSL certificate'
  sites_resources.each do |site_resource|
    describe site_resource do
      it { should exist }
    end
  end
end

control '02-ssl-is-trusted' do
  impact 0.8
  title 'Ensure that all sites return a trusted SSL certificate'
  sites_resources.each do |site_resource|
    describe site_resource do
      it { should be_trusted }
    end
  end
end

control '03-no-ssl-error' do
  impact 0.9
  title 'Ensure that no SSL negotiation error has been encountered'
  sites_resources.each do |site_resource|
    describe site_resource do
      its('ssl_error') { should eq nil }
    end
  end
end

control '04-ssl-sign-algo' do
  impact 0.6
  title 'Ensure that the signature algorithm is sha256WithRSAEncryption'
  sites_resources.each do |site_resource|
    describe site_resource do
      its('signature_algorithm') { should eq 'sha256WithRSAEncryption' }
    end
  end
end

control '05-ssl-hash-algo' do
  impact 0.6
  title 'Ensure that the hash algorithm is SHA256'
  sites_resources.each do |site_resource|
    describe site_resource do
      its('hash_algorithm') { should eq 'SHA256' }
    end
  end
end

control '06-ssl-expire' do
  impact 0.7
  title 'Ensure the SSL certificates have over 30 days before they expire'
  sites_resources.each do |site_resource|
    describe site_resource do
      its('expiration_days') { should be > 30 }
    end
  end
end

control '07-ssl-issuer' do
  impact 0.4
  title 'Ensure the SSL certificate has the correct issuer'
  sites_resources.each do |site_resource|
    describe site_resource do
      its('issuer_organization') { should be_in ["Amazon", "Let's Encrypt", "DigiCert Inc", "GlobalSign nv-sa", "Sectigo Limited"] }
    end
  end
end
