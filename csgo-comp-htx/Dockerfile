FROM csgo-warmod:latest

ADD HTX-LAN-18/first_run/* /steam/csgo/csgo/

# Apparently warmod craps over files the first time it runs, so we 
# run csgo to get that out of its system and re-clobber ourselves
RUN timeout --preserve-status 15 ./srcds_run -game csgo  || true

ADD HTX-LAN-18/second_run/cfg/ /steam/csgo/csgo/cfg/
ADD start-comp.sh /steam/csgo/

ADD HTX-LAN-18/second_run/addons/sourcemod/configs/ /steam/csgo/csgo/addons/sourcemod/configs/

USER root
RUN chown -R steam:steam /steam/csgo/csgo/cfg
RUN chown -R steam:steam /steam/csgo/csgo/addons/sourcemod/configs
USER steam

ENTRYPOINT ["./start-comp.sh"]
CMD ["0"]
