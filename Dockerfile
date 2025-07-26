FROM ubuntu:22.04

COPY setup-vnc.sh /setup-vnc.sh
COPY setup-steam.sh /setup-steam.sh
COPY run_smapi.sh /run_smapi.sh

RUN chmod +x /setup-vnc.sh /setup-steam.sh /run_smapi.sh

RUN ln -s /run_smapi.sh /usr/local/bin/stardew

CMD ["/bin/bash", "/setup-vnc.sh"]