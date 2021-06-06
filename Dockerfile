FROM node:14-alpine as build

ENV TERM=dumb \
    LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib

# Create a subuser so that NPM doesn't whine about running as root
RUN adduser -D -H -h /usr/src/app web && \
    mkdir -p /usr/src/app && \
    chown web:web /usr/src/app && \
    # Install dependencies
    apk add --no-cache \
      ca-certificates wget \
      tar bash curl perl-utils \
      gcc musl-dev make m4 \
      python g++ libev libev-dev linux-headers \
      git patch ncurses jq && \
    # esy is dynamically linked to glibc, not compiled locally. Oh well.
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk && \
    apk add --no-cache glibc-2.28-r0.apk && \
    # --unsafe-perm because we want to install esy globally as root
    npm install -g --unsafe-perm esy

# Use the new user for the build
WORKDIR /usr/src/app
USER web

COPY --chown=web:web ./ ./

# Build backend
RUN cd chatwheel_backend && \
    rm -rf _esy && \
    esy && \
    jq '.buildDirs.lib.flags = ["-ccopt", "-static"]' package.json > package.json.new && \
    mv package.json.new package.json && \
    SHELL=sh esy && \
    cp _esy/default/build/default/lib/chatwheel_backend.exe /usr/src/app && \
    cp -r priv /usr/src/app

# Build frontend
RUN cd chatwheel_frontend && \
    rm -rf _esy && \
    SHELL=sh esy && \
    npm run webpack:production && \
    cp -r build /usr/src/app/assets

ENTRYPOINT ["/usr/src/app/chatwheel_backend.exe"]
