<h2>Introduction</h2>
This is a simple UK postcode checking app that enables you to specify your own supported postcodes paired
with LSOAs (Lower Layer Super Output Area) they belong to. Upon entering a postcode, the application will
first check against the supported postcodes list and then fallback onto
<a href="http://postcodes.io/">Postcodes.io</a> service that offers postcode lookups and returns detailed
postcode info, including postcode's LSOA, that is then checked against supported LSOAs list.

<h2>Installing the app</h2>
You'll need a Ruby environment installed (version and gemset are specified for
<a href="https://rvm.io/">RVM</a> users). You'll also need
<a href="https://docs.docker.com/engine/install/ubuntu/">Docker engine</a> and
<a href="https://docs.docker.com/compose/install/">docker-compose tool</a> installed
as the app uses PostgreSQL database, and instead of installing and setting up database, a docker image
is used.

Step by step for fresh Ubuntu installations:

<h3>Installing RVM</h3>
<pre><code>sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm
source /etc/profile.d/rvm.sh</code></pre>

Install git if not already installed and clone the repository:

<pre><code>sudo apt-get install git
git clone https://github.com/Pinelynx/postcode-checker.git</code></pre>

Change directory to project root

<code> cd postcode-checker</code>

If Ruby version 3.0.0 is not installed you'll get the following message:
<pre><code>Required ruby-3.0.0 is not installed.
To install do: 'rvm install "ruby-3.0.0"'</code></pre>

Install the needed version by using the above displayed command:

<code>rvm install "ruby-3.0.0"</code>

You might run into some issues while installing the ruby version, those are tied to permissions and shell not
recognizing rvm command properly. Fixing them depends on the OS, in my case following and relog worked:

<code>echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" >> ~/.bashrc</code>

If the correct version is installed you'll get the message that postcode-checker gemset is installed, which
you can easily later remove when no longer needed:

<code>rvm gemset delete postcode-checker</code>

<h3>Installing gems</h3>

Install the necessary gems by running:

<code>bundle install</code>

There is a chance installing the gem will fail as pg gem dependencies might be missing, you can get them
by using:

<code>sudo apt-get install libpq-dev</code>

<h3>Installing Docker engine</h3>

Next is installing Docker engine (see <a href="https://docs.docker.com/engine/install/ubuntu/">instructions</a>):
<pre><code>curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
</code></pre>

And then, to see if it works:

<code>sudo docker run hello-world</code>

Next and final prerequisite is installing the docker-compose tool
(see <a href="https://docs.docker.com/compose/install/">instructions</a>):
<pre><code>sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose</code></pre>

And finally, to see if it works:

<code>docker-compose --version</code>

After that, from the project root directory, you should be able to run:

<code>sudo docker-compose up -d</code>

And the database service should now be up. To shut it down, use:

<code>sudo docker-compose down</code>

<h2>Running the app</h2>
Make a copy of <code>.env.example</code> file and name it <code>.env</code>,
from it environment variables will be read:

<code>cp .env.example .env</code>

Get the database ready:
<pre><code>rails db:create
rails db:migrate
rails db:seed
rails db:test:prepare
</code></pre>

Run all the spec and rubocop:
<pre><code>rspec
rubocop
</code></pre>

And finally, run the application:

<code>rails s</code>

Postcode checking form is available both on root path and /check_postcode path

Application is preseeded with supported LSOAs:
- Southwark
- Lambeth
- Custom

And also with supported postcodes tied to "Custom" LSOA:
- SH24 1AA
- SH24 1AB

<h3>TL;DR: if you have everything set up</h3>

<pre><code>git clone https://github.com/Pinelynx/postcode-checker.git
cd postcode-checker
cp .env.example .env
sudo docker-compose up -d
rails db:migrate
rails db:seed
rails db:test:prepare
rspec
rubocop
rails s
sudo docker-compose down</code></pre>