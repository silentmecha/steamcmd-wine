FROM steamcmd/steamcmd:ubuntu-24

LABEL maintainer="silent@silentmecha.co.za"

ARG PUID=1001
ARG DEBIAN_FRONTEND=noninteractive

# Runtime configuration
# These defaults are inherited by child images.
ENV USER=steam
ENV HOME="/home/${USER}"

ENV AUTO_UPDATE=False
ENV BACKUP_DAILY_LIM=5
ENV BACKUP_HOURLY_LIM=5

# Global save-data location.
# Child images should map game-specific save locations into this directory.
ENV STEAM_SAVEDIR="${HOME}/save-data"

# Create service user.
# Dedicated game servers should not run as root.
RUN set -x \
    && useradd -u "${PUID}" -m "${USER}"

# Install common utilities and Wine dependencies.
# gettext-base provides envsubst for template rendering.
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        nano \
        curl \
        wget \
        jq \
        tzdata \
        rename \
        gettext-base \
        wine-stable \
        wine32 \
        wine64 \
        libwine \
        libwine:i386 \
        xvfb \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Set working directory.
WORKDIR "${HOME}"

COPY ./src/ssq "${HOME}/ssq"
COPY ./src/healthcheck.sh "${HOME}/healthcheck.sh"

# Create persistent save-data directory.
RUN set -x \
    && mkdir -p "${STEAM_SAVEDIR}" \
    && chown "${USER}:${USER}" "${STEAM_SAVEDIR}" \
    && chmod 775 "${STEAM_SAVEDIR}"

# Configure helper scripts.
RUN set -x \
    && chown "${USER}:${USER}" "${HOME}/ssq" "${HOME}/healthcheck.sh" \
    && chmod +x "${HOME}/ssq" "${HOME}/healthcheck.sh"

# Expose persistent storage location.
VOLUME ["/home/steam/save-data"]

USER "${USER}"

# Update SteamCMD and verify installation.
RUN steamcmd +quit

# Create compatibility symlinks expected by some dedicated servers.
RUN mkdir -p "${HOME}/.steam" \
    && ln -s "${HOME}/.local/share/Steam/steamcmd/linux32" "${HOME}/.steam/sdk32" \
    && ln -s "${HOME}/.local/share/Steam/steamcmd/linux64" "${HOME}/.steam/sdk64" \
    && ln -s "${HOME}/.steam/sdk32/steamclient.so" "${HOME}/.steam/sdk32/steamservice.so" \
    && ln -s "${HOME}/.steam/sdk64/steamclient.so" "${HOME}/.steam/sdk64/steamservice.so"

# Default container behaviour.
# Child images are expected to override these values.
ENTRYPOINT []

CMD ["/bin/bash"]
