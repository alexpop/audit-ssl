# audit-ssl profile

Sample profile with test controls defined in the `controls` directory to check the HTTPS SSL certificate (validity, encryption, expiry, etc) on a list of hostnames. The list of hostnames is predefined but it can also be queried dynamically at runtime from AWS Route53, Azure, Cloudflare, etc

This profile depends on the library [ssl-certificate-profile](https://github.com/alexpop/ssl-certificate-profile) for the custom `ssl_certificate` resource it contains.

## Requirements

### Clone this repository to a local directory, e.g. `~/git/audit-ssl`

^ Update the `sites` variable in the `controls/default.rb` file with your target sites to check.

> ℹ️  In the commands bellow, if you are using **cinc-auditor** instead of **Chef InSpec**, replace `inspec` with `cinc-auditor`.

### Install **Chef InSpec** or **cinc-auditor** (OpenSource version of **InSpec**)

 * **Chef InSpec** can be downloaded from here:
https://downloads.chef.io/products/inspec

 * **cinc-auditor** can be downloaded from here:
http://downloads.cinc.sh/files/stable/cinc-auditor/

Once installed, you can verify the version you have from the command line with:

```bash
$ inspec -v
4.22.8
```

### Execute the profiles

 * with results on screen:

```bash
$ inspec exec ~/git/audit-ssl
```

* with results to a json file
```bash
$ inspec exec ~/git/audit-ssl --reporter json
```

Or install an advanced html reporter via a custom plugin:
```bash
git clone https://github.com/alexpop/inspec-reporter-pophtml.git
inspec plugin install inspec-reporter-pophtml
```

and get an html report generated with this new plugin like this:
```bash
inspec exec ~/git/audit-ssl --reporter pophtml:/tmp/ssl-pophtml.html
```

^ will create a local file `/tmp/ssl-pophtml.html` that is a standalone and user friendly html report with no external dependencies (javascript, css, etc). Explore it, print it as pdf or on paper.
