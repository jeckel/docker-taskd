FROM alpine:latest
LABEL authors="Andreas Rammhold (andreas@rammhold.de),Julien Mercier-Rojas (julien@jeckel-lab.fr)"

# Install necessary stuff
RUN apk -U --no-progress upgrade && \
    apk -U --no-progress add taskd taskd-pki

# Import build and startup script
COPY docker /app/taskd/

# Set the data location
ARG TASKDDATA
ENV TASKDDATA=${TASKDDATA:-/var/taskd}
ENV TASKD_ORGANIZATION=Public
ENV TASKD_USERNAME=Bob
ENV CLIENT_CERT_PATH=/var/taskd/client

# Configure container
VOLUME ["${TASKDDATA}"]
EXPOSE 53589
ENTRYPOINT ["/app/taskd/run.sh"]
