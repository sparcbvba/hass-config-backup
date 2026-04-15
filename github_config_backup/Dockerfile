FROM alpine:latest

# Installeer bash, jq (voor het lezen van opties) en git
RUN apk add --no-cache bash jq git

# Kopieer het script naar de container
COPY run.sh /
RUN chmod a+x /run.sh

# Start het script wanneer de add-on start
CMD [ "/run.sh" ]