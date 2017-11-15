{% if (pillar['pkg'] is defined) and (pillar['pkg'] is not none) %}
  {%- if (pillar['pkg']['app'] is defined) and (pillar['pkg']['app'] is not none) %}
    {%- for pkg_key, pkg_val in pillar['pkg']['app'].items()|sort %}
      {%- set out_loop = loop %}
      {%- if (pkg_val['pkg_installed'] is defined) and (pkg_val['pkg_installed'] is not none) %}
pkg_app_installed_{{ loop.index }}:
  pkg.installed:
    - pkgs:
        {{ pkg_val['pkg_installed'] }}

      {%- endif %}
      {%- if (pkg_val['files_managed'] is defined) and (pkg_val['files_managed'] is not none) %}
        {%- for fm_key, fm_val in pkg_val['files_managed'].items()|sort %}
pkg_files_managed_{{ out_loop.index }}_{{ loop.index }}:
  file.managed:
          {%- if not ((fm_val['name'] is defined) and (fm_val['name'] is not none)) %}
    - name: {{ fm_key }}
          {%- endif %}
{{ fm_val|yaml(False)|indent(width=4,indentfirst=True) }}

        {% endfor %}
      {%- endif %}
      {%- if (pkg_val['cmd_run'] is defined) and (pkg_val['cmd_run'] is not none) %}
        {%- for cr_key, cr_val in pkg_val['cmd_run'].items()|sort %}
pkg_cmd_run_{{ out_loop.index }}_{{ loop.index }}:
  cmd.run:
          {%- if not ((cr_val['name'] is defined) and (cr_val['name'] is not none)) %}
    - name: {{ cr_key }}
          {%- endif %}
{{ cr_val|yaml(False)|indent(width=4,indentfirst=True) }}

        {% endfor %}
      {%- endif %}
    {%- endfor %}
  {%- endif %}
{% endif %}
