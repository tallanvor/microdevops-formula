test_hostname_equals_id:
  cmd.run:
    - name: |
        grep x{{ grains["id"] }} /etc/hostname && \
        grep {{ grains["id"] }} /etc/hosts && \
        hostname | grep {{ grains["id"] }} && \
        hostname -f | grep {{ grains["id"] }} 
