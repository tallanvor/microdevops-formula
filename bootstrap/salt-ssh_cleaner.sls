cron_tmp_remove:
  cron.present:
    - name: /usr/bin/find /var/tmp -name '.root_*_salt' -mtime +1
    - identifier: Clean unnecessary Salt files
    - user: root
    - minute: 26
    - hour: 3
