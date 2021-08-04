{% if pillar["drweb"] is defined %}
drweb_install_00:
  pkgrepo.managed:
    - humanname: Dr.Web Repository
    - name: deb http://repo.drweb.com/drweb/debian 11.1 non-free
    - file: /etc/apt/sources.list.d/drweb.list
    - keyid: 8C42FC58D8752769
    - keyserver: keyserver.ubuntu.com

drweb_install_01:
  pkg.installed:
    - refresh: True
    - reload_modules: True
    - pkgs:
        #- drweb-mail-servers
        - drweb-maild
        - drweb-se
        - drweb-dws
        - drweb-antispam
        - drweb-vaderetro
        - drweb-httpd
        - drweb-openssl

drweb_log_dir:
  file.directory:
    - name: /var/log/drweb
    - mode: 755
    - user: drweb
    - group: drweb

drweb_configure_00:
  cmd.run:
    - name: drweb-ctl cfset HTTPD.AdminListen {{ pillar["drweb"]["ip"] }}:443
drweb_configure_01:
  cmd.run:
    - name: drweb-ctl cfset HTTPD.AdminSslCertificate /opt/acme/cert/{{ pillar["drweb"]["servername"] }}/fullchain.cer
drweb_configure_02:
  cmd.run:
    - name: drweb-ctl cfset HTTPD.AdminSslKey /opt/acme/cert/{{ pillar["drweb"]["servername"] }}/{{ pillar["drweb"]["servername"] }}.key
drweb_configure_03:
  cmd.run:
    - name: drweb-ctl cfset ScanEngine.Log /var/log/drweb/scanning_engine.log
drweb_configure_04:
  cmd.run:
    - name: drweb-ctl cfset ScanEngine.LogLevel {{ pillar["drweb"]["ScanEngine_LogLevel"] }}
drweb_configure_05:
  cmd.run:
    - name: drweb-ctl cfset MailD.LogLevel {{ pillar["drweb"]["MailD_LogLevel"] }}
drweb_configure_06:
  cmd.run:
    - name: drweb-ctl cfset MailD.Log /var/log/drweb/maild.log
drweb_configure_07:
  cmd.run:
    - name: drweb-ctl cfset MailD.RepackPassword "HMAC({{ pillar["drweb"]["secret_word"] }})"
drweb_configure_08:
  cmd.run:
    - name: drweb-ctl cfset MailD.MilterDebugIpc {{ pillar["drweb"]["MailD_MilterDebugIpc"] }}
drweb_configure_09:
  cmd.run:
    - name: drweb-ctl cfset MailD.MilterTraceContent {{ pillar["drweb"]["MailD_MilterTraceContent"] }}
drweb_configure_10:
  cmd.run:
    - name: drweb-ctl cfset MailD.MilterSocket {{ pillar["drweb"]["ip"] }}:{{ pillar["drweb"]["smtp_milter_port"] }}
drweb_configure_11:
  cmd.run:
    - name: drweb-ctl cfset Antispam.LogLevel {{ pillar["drweb"]["Antispam_LogLevel"] }}
drweb_configure_12:
  cmd.run:
    - name: drweb-ctl cfset Antispam.Log /var/log/drweb/antispam.log

{% endif %}