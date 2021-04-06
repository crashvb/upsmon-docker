FROM crashvb/supervisord:202103212252
LABEL maintainer "Richard Davis <crashvb@gmail.com>"

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
