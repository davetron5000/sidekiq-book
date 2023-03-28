FROM ruby:3.2

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q && \
    apt-get install -qy rsync

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
		wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
		apt-get update && \
		apt-get -y install postgresql-client-15

RUN apt-get -y install chromium chromium-driver

# Now, we set up RubyGems to avoid building documentation. We don't need the docs
# inside this image and it slows down gem installation to have them.
# We also install the latest bundler as well as Rails.  Lastly, to help debug stuff inside
# the container, I need vi mode on the command line and vim to be installed.  These can be 
# omitted and aren't needed by the Rails toolchain.
RUN gem update --system && \
    echo "gem: --no-document" >> ~/.gemrc && \
    gem install bundler && \
    echo "set -o vi" >> ~/.bashrc && \
    apt-get -y install vim

ENV BINDING="0.0.0.0"

# This sets up an SSH server that you should not use as a reference for running
# SSH in production :)  It's here because the toolchain used for writing
# the book will ssh into the container and run the commands/edit the code
# the way the book says to.  The server being run here will only be available
# to containers on the same network, so this is generally safe, but if it
# bothers you, you can safely remove this RUN directive as well as
# the COPY and RUN directives that follow it.
RUN apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    echo 'root:password' | chpasswd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/# PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "# When the toolchain executes code via ssh, none of the env vars are preserved, so" && \
    echo "# we need to store them in /etc/environment, which is where env vars go to affect anything" && \
    echo "# including non-iteractive shells" && \
    echo "# Set here from Dockerfile so that ssh'ing in preserves these"   >> /etc/environment && \
    echo "export BUNDLE_APP_CONFIG=$BUNDLE_APP_CONFIG"                     >> /etc/environment && \
    echo "export BUNDLE_SILENCE_ROOT_WARNING=$BUNDLE_SILENCE_ROOT_WARNING" >> /etc/environment && \
    echo "export GEM_HOME=$GEM_HOME"                                       >> /etc/environment && \
    echo "export PATH=$PATH"                                               >> /etc/environment && \
    echo "export RUBY_DOWNLOAD_SHA256=$RUBY_DOWNLOAD_SHA256"               >> /etc/environment && \
    echo "export RUBY_MAJOR=$RUBY_MAJOR"                                   >> /etc/environment && \
    echo "export RUBY_VERSION=$RUBY_VERSION"                               >> /etc/environment && \
    echo "export BINDING=$BINDING"                                         >> /etc/environment && \
    echo "# END Set here from Dockerfile"                                  >> /etc/environment && \
    mkdir -p /root/.ssh

# This COPY and RUN are the other directives you can remove if you don't
# want the ssh server in here
COPY authorized_keys /root/.ssh/
RUN chmod 644 ~/.ssh/authorized_keys

# This entrypoint produces a nice help message and waits around for you to do
# something with the container.
COPY ./docker-entrypoint.sh /root
