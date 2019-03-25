{% if pillar['salt'] is defined and pillar['salt'] is not none and pillar['salt']['master'] is defined and pillar['salt']['master'] is not none %}
salt_master_repo:
  pkgrepo.managed:
    - humanname: SaltStack Repository
    - name: deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/2019.2 xenial main
    - name: deb http://repo.saltstack.com/apt/ubuntu/{{ grains['osrelease'] }}/amd64/{{ pillar['salt']['master']['version'] }} {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/saltstack.list
    - key_url: https://repo.saltstack.com/apt/ubuntu/{{ grains['osrelease'] }}/amd64/{{ pillar['salt']['master']['version'] }}/SALTSTACK-GPG-KEY.pub

salt_master_pkg:
  pkg.latest:
    - refresh: True
    - pkgs:
        - salt-master
        - salt-ssh

salt_master_config:
  file.serialize:
    - name: /etc/salt/master
    - user: root
    - group: root
    - mode: 644
    - show_changes: True
    - create: True
    - merge_if_exists: False
    - formatter: yaml
    - dataset: {{ pillar['salt']['master']['config'] }}

salt_master_service:
  cmd.run:
    - name: service salt-master restart

  {%- if pillar['salt']['master']['repo'] is defined and pillar['salt']['master']['repo'] is not none %}
salt_master_deploy_repo:
  cmd.run:
    - name: |
        [ -d /srv/.git ] || ( cd /srv && git init . && git remote add origin {{ pillar['salt']['master']['repo'] }} && GIT_SSH_COMMAND="ssh -o BatchMode=yes -o StrictHostKeyChecking=no" git pull origin master && GIT_SSH_COMMAND="ssh -o BatchMode=yes -o StrictHostKeyChecking=no" git submodule init && GIT_SSH_COMMAND="ssh -o BatchMode=yes -o StrictHostKeyChecking=no" git submodule update --recursive -f --checkout && git branch --set-upstream-to=origin/master master )

  {%- endif %}
{% endif %}
