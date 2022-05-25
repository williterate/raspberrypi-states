piaware:
  pkgrepo.managed:
    - name: deb http://flightaware.com/adsb/piaware/files/packages bullseye piaware
    - file: /etc/apt/sources.list.d/piaware.list
    - key_text: |
        -----BEGIN PGP PUBLIC KEY BLOCK-----

        mQINBFQp58QBEADVe1aklQJZ9qwJGqDI68sxwe/25XkaazmklWgpafIkqRk5HtnY
        n37iSn0RQrd+ggKQJ+fYUb+hcUCKf6BegNhJAEW1HId6pagUXhCAm/T7DQbphv0b
        mzzIpna2FN02xqL9wNfc+druZUEvNvicktymxdrVXX3hsYSP7b80e7Vsc1R0pcsw
        xR9Sr2HRn9g4JUIUBC3WYMw14wCUCIRHWXcSEhOZEJsPcZ5XknNR6F7ydzPhTDC/
        5TxXEtGmybuatE9p36dk9VPPn/oqq8SCJdhjjPth0Cu4xsYm/no984D8hN4phqsw
        HFYd7Uf93VhOiHZqlExMgQWZsv7cS1wCKBvjerAWcBCE4Iwhxbdi1RHRO9w3U2z5
        P4hAxmdCncQdVTMPlaDfwAyyuGN1Qx3ji2uIahuH7W2pX5U5RH4csZpfnP9t6szh
        cxnNO5t7NFOOaxP8TJ00iZIP6aP3fELZ2yieZsJpJ8gwFldNOzbL/UwKgkJAClGj
        1sKFZ1yzzbbwmTO+tztzuYUuU1gri9Dy/J73sRWgUVgxPzf2Ng9HOYEeOwzYNUEp
        /ozPGHZtAaazI8xfsh6jcTiauWxaBvVZRW09PS9wwxcUDoc/3aLu8WoPuLpSjrYC
        yucS6F/+3JVbcwPyV19nLZUsKmmDRoNKIjSCcbK9wEKe2KpNeQY+aiqo4wARAQAB
        tDJGbGlnaHRBd2FyZSBEZXZlbG9wZXJzIDxhZHNiLWRldnNAZmxpZ2h0YXdhcmUu
        Y29tPokCOAQTAQIAIgUCVCnnxAIbAwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AA
        CgkQuTG7KN6F8N2AmRAAlyS82cTY2wL9LfaDhXtGFJb/rYLjy9pa7r5p5w8VONcq
        2Xsq1KUjkk4CncaWEDmK4qu3jYAFfy2HUF2WDzAxc2vo1/jLRmLx8BP0Z1lfFBKo
        VhvPgHb77SqSTW8pdY3AJyiKdiaX8mA77T9rle2HSlZPZhdobiSv+acYHD2UUZmd
        w5LEKl2UDv6cM5vYKlYglQxGqVd/O4plFQUoW+rGKVkXYf3YajbS4Zde6c3n0isG
        6EmdmWSz02uHAbw8rW8pj7c7Kx9iTNVbpQOYXPabl9/Bd282/uE8LDLtwwxRZljK
        Ry+TKRboCC7mA1QJr8dhANlBPRDs/1twNTJakutaFlVAcjB01OX8n9lzGlXpkCcA
        UnbXAT0n+UsLLhxZWtBKNjn9BopB5aDc/bC2HARz/5lrMV9vfEcQs/a29ToOtzjI
        qefoBGzWKrTEAXDZrQbKGprVqWfKKrZirTse8E1fjcmI3ar3B4rusUswRRHRckLS
        qIacqz6WstZ8MoDSTzsiottTjmgXQWEinUaMnjaifT/Pc3fS+4k+sd++dYDjhSdK
        +fr8cIEPCUUu8Qg5sgkCgco2WaC7OGFaotdeIIZPoaZ/OGkS/Ih5RmdIBCchaWHW
        l88SUTUaEAeVRRGqPb/HzLOykPYeLWnB+TawdEF9chxstd4ZaMqJTDcyXOwEd9o=
        =dxeZ
        -----END PGP PUBLIC KEY BLOCK-----
    - clean_file: True
  pkg.latest:
    - install_recommends: False
    - pkgs:
        - dump1090-fa
        - piaware
    - require:
        - pkgrepo: piaware
  service.running:
    - enable: True
  # Remove user from lightdm login window.
  user.present:
    - shell: /usr/sbin/nologin

/var/cache/piaware/feeder_id:
  file.managed:
    - contents: "{{ pillar['piaware_feeder_id'] }}"
    - watch_in:
        - service: piaware

/var/cache/piaware/location:
  file.managed:
    - contents: |
        {{ pillar['piaware_latitude'] }}
        {{ pillar['piaware_longitude'] }}
    - watch_in:
        - service: piaware

/var/cache/piaware/location.env:
  file.managed:
    - contents: |
        PIAWARE_LAT="{{ pillar['piaware_latitude'] }}"
        PIAWARE_LON="{{ pillar['piaware_longitude'] }}"
        PIAWARE_DUMP1090_LOCATION_OPTIONS="--lat {{ pillar['piaware_latitude'] }} --lon {{ pillar['piaware_longitude'] }}"
    - watch_in:
        - service: piaware
