FROM debian:bookworm-slim AS fetch

ARG WINBOX_URL
ARG WINBOX_SHA256

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates curl unzip && \
    curl -fsSL "${WINBOX_URL}" -o /tmp/winbox.zip && \
    echo "${WINBOX_SHA256}  /tmp/winbox.zip" | sha256sum -c - && \
    mkdir -p /out/opt/winbox && \
    unzip -q /tmp/winbox.zip -d /out/opt/winbox && \
    test -x /out/opt/winbox/WinBox && \
    rm -rf /var/lib/apt/lists/* /tmp/winbox.zip

FROM debian:bookworm-slim

ARG UID=2000

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      dbus-x11 \
      i3-wm \
      xdotool \
      libxcb-glx0 \
      libxkbcommon-x11-0 \
      libxkbcommon0 \
      libxcb-icccm4 \
      libxcb-image0 \
      libxcb-keysyms1 \
      libxcb-randr0 \
      libxcb-render-util0 \
      libxcb-shm0 \
      libxcb-sync1 \
      libxcb-xfixes0 \
      libxcb-render0 \
      libxcb-shape0 \
      libxcb-xkb1 \
      libxcb1 \
      libx11-xcb1 \
      libegl1 \
      libgl1 \
      libfreetype6 \
      libfontconfig1 \
      libx11-6 \
      libdbus-1-3 \
      zlib1g \
      libxcb-cursor0 \
      fonts-dejavu-core && \
    useradd -l --create-home --shell /bin/sh -u ${UID} --user-group debian && \
    mkdir -p /home/debian/.config/i3 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=fetch /out/opt/winbox /opt/winbox
COPY start.sh /start.sh
COPY i3config /home/debian/.config/i3/config

RUN chmod 0755 /start.sh /opt/winbox/WinBox && \
    chown -R debian:debian /home/debian /opt/winbox

USER debian
ENV HOME=/home/debian
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
WORKDIR /home/debian

ENTRYPOINT ["/start.sh"]
