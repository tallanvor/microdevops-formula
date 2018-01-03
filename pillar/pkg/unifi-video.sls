{% from '/srv/pillar/pkg/unifi-video.jinja' import unifi_server_name with context %}
{% from '/srv/pillar/pkg/unifi-video.jinja' import unifi_admin_email with context %}

pkg:
  unifi-video:
    when: 'PKG_AFTER_DEPLOY'
    states:
      - pkgrepo.managed:
          1:
            - humanname: 'NginX Official Repo'
            - name: 'deb http://nginx.org/packages/mainline/{{ grains['os']|lower }}/ {{ grains['oscodename'] }} nginx'
            - file: '/etc/apt/sources.list.d/nginx.list'
            - keyid: 'ABF5BD827BD9BF62'
            - keyserver: 'keyserver.ubuntu.com'
      - pkg.installed:
          1:
            - skip_verify: True
            - pkgs:
                - unifi-video
                - nginx
      - file.managed:
          '/etc/nginx/nginx.conf':
            - source: 'salt://pkg/files/unifi-video/nginx.conf'
            - template: jinja
            - defaults:
                server_name: '{{ unifi_server_name }}'
      - file.directory:
          '/var/www/.well-known/':
            - makedirs: True
      - cmd.run:
          1:
            - name: 'ln -f -s /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/nginx/fullchain.pem'
          2:
            - name: 'ln -f -s /etc/ssl/private/ssl-cert-snakeoil.key /etc/nginx/privkey.pem'
          3:
            - name: 'service nginx restart'
          4:
            - name: '/opt/certbot/certbot-auto -n certonly --webroot --reinstall --agree-tos --cert-name unifi-video --email {{ unifi_admin_email }} -w /var/www -d {{ unifi_server_name }}'
          5:
            - name: 'test -f /etc/letsencrypt/live/unifi-video/fullchain.pem && ln -s -f /etc/letsencrypt/live/unifi-video/fullchain.pem /etc/nginx/fullchain.pem || true'
          6:
            - name: 'test -f /etc/letsencrypt/live/unifi-video/privkey.pem && ln -s -f /etc/letsencrypt/live/unifi-video/privkey.pem /etc/nginx/privkey.pem || true'
          7:
            - name: 'service nginx configtest && service nginx restart'
      - cron.present:
          '/opt/certbot/certbot-auto renew --renew-hook "service nginx configtest && service nginx restart"':
            - identifier: 'certbot_cron'
            - user: root
            - minute: 10
            - hour: 2
            - dayweek: 1
