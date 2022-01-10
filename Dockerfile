FROM crashvb/supervisord:202201080446@sha256:8fe6a411bea68df4b4c6c611db63c22f32c4a455254fa322f381d72340ea7226
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:8fe6a411bea68df4b4c6c611db63c22f32c4a455254fa322f381d72340ea7226" \
	org.opencontainers.image.base.name="crashvb/supervisord:202201080446" \
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
ADD supervisord.upsmon.conf /etc/supervisor/conf.d/upsmon.conf

# Configure: entrypoint
ADD entrypoint.upsmon /etc/entrypoint.d/upsmon

VOLUME ${NUT_CONFPATH}
