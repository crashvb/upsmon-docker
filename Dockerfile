FROM crashvb/supervisord:202303031721@sha256:6ff97eeb4fbabda4238c8182076fdbd8302f4df15174216c8f9483f70f163b68
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:6ff97eeb4fbabda4238c8182076fdbd8302f4df15174216c8f9483f70f163b68" \
	org.opencontainers.image.base.name="crashvb/supervisord:202303031721" \
	org.opencontainers.image.created="${org_opencontainers_image_created}" \
	org.opencontainers.image.description="Image containing upsmon." \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.source="https://github.com/crashvb/upsmon-docker" \
	org.opencontainers.image.revision="${org_opencontainers_image_revision}" \
	org.opencontainers.image.title="crashvb/upsmon" \
	org.opencontainers.image.url="https://github.com/crashvb/upsmon-docker"

# Install packages, download files ...
RUN docker-apt libnss3-tools nut-client ssl-cert

# Configure: upsmon
ENV NUT_CONFPATH=/etc/nut UPSMON_NSS_PATH=/etc/nut/nss
RUN usermod --append --groups ssl-cert nut && \
	install --directory --group=root --mode=0775 --owner=root /usr/local/share/nut && \
	sed --expression="/^MODE=/s/none/netclient/" \
		--in-place=.dist ${NUT_CONFPATH}/nut.conf && \
	sed --expression="/^POWERDOWNFLAG /s/etc/tmp/" \
		--expression="/^# CERTPATH \/usr/cCERTPATH ${UPSMON_NSS_PATH}" \
		--in-place=.dist ${NUT_CONFPATH}/upsmon.conf && \
	mv ${NUT_CONFPATH} /usr/local/share/nut/config

# Configure: supervisor
COPY supervisord.upsmon.conf /etc/supervisor/conf.d/upsmon.conf

# Configure: entrypoint
COPY entrypoint.upsmon /etc/entrypoint.d/upsmon

# Configure: healthcheck
COPY healthcheck.upsmon /etc/healthcheck.d/upsmon

VOLUME ${NUT_CONFPATH}
