FROM ruby:3.0.4-alpine3.16

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/ \
    SEXY_SETTINGS_DELIMITER=";" \
    SEXY_SETTINGS="driver=headless_chrome; headless_chrome_flags=window-size=1920x1080, disable-gpu, no-sandbox, disable-dev-shm-usage, disable-software-rasterizer"

RUN bundle config --global frozen 1
RUN apk update && apk upgrade --no-cache --available \
    && apk add --no-cache \
      chromium firefox \
      chromium-chromedriver \
      ttf-freefont \
      font-noto-emoji \
      build-base bash \
      curl \
      git \
      less dbus \
    && apk add --no-cache \
      --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing font-wqy-zenhei \
    && wget https://github.com/mozilla/geckodriver/releases/download/v0.31.0/geckodriver-v0.31.0-linux64.tar.gz \
    && tar -zxf geckodriver-v0.31.0-linux64.tar.gz -C /usr/bin

RUN dbus-daemon --system

WORKDIR /home/howitzer_example

COPY Gemfile Gemfile.lock /home/howitzer_example/
RUN bundle install
COPY . .

ENTRYPOINT bundle exec rake
