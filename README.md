# child_ps

## Zabbix template for monitoring of child processes on Linux host 

Installation:

    - name: child processes data script
      copy:
        src: 'child_ps.sh'
        dest: '/etc/zabbix/scripts/child_ps.sh'
        mode: 0755
      notify: restart zabbix-agent

    - name: child processes conf
      copy:
        src: 'child_ps.conf'
        dest: '/etc/zabbix/zabbix_agentd.d/child_ps.conf'
        mode: 0644
      notify: restart zabbix-agent
