FROM ruby:2.3
RUN uname -a
RUN gem install bundler
# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN echo "deb http://ftp.us.debian.org/debian jessie main contrib non-free" | tee -a /etc/apt/sources.list
RUN echo "deb http://security.debian.org/ jessie/updates contrib non-free" | tee -a /etc/apt/sources.list
RUN  apt-get update -yq \
    && apt-get install curl gnupg -yq \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash \
    && apt-get install nodejs -yq

RUN apt-get install -y libfreetype6 libfontconfig1 libnss3-dev libgconf-2-4
RUN npm install npm
RUN gem install bundler
#is this needed?
RUN gem install aws-sdk --no-rdoc --no-ri

# Make sure decent fonts are installed. Thanks to http://www.dailylinuxnews.com/blog/2014/09/things-to-do-after-installing-debian-jessie/
RUN apt-get install -y ttf-freefont ttf-mscorefonts-installer ttf-bitstream-vera ttf-dejavu ttf-liberation

# Make sure a recent (>6.7.7-10) version of ImageMagick is installed.
RUN apt-get install -y imagemagick

RUN useradd -u 1000 acceptance_test
COPY . /home/acceptance_test/app
COPY secrets/id_rsa /home/acceptance_test/.ssh/
COPY secrets/known_hosts /home/acceptance_test/.ssh/
RUN chmod 400 /home/acceptance_test/.ssh/id_rsa
RUN chown -R acceptance_test:acceptance_test /home/acceptance_test
WORKDIR /home/acceptance_test/app
RUN mkdir /home/acceptance_test/output

RUN bundle install
#RUN wraith history ontruck_home
#ENTRYPOINT [ "/bin/wraith" ]
