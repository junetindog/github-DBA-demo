set lines 1000 pages 1000
col UPTIME for a80
select'Hostname      : '||i.host_name||chr(10)||'Instance Name : '||i.
instance_name||chr(10)||'Status        : '||i.database_status||' and '||i.status
||chr(10)||'Started At    : '||to_char(i.startup_time,'DD-MON-YYYY HH24:MI:SS')
||chr(10)||'Appl Sessions : '||nvl(s.sessions,0)||chr(10)||'Appl Processes: '||
nvl(p.process,0)||chr(10)||'Locked Objects: '||nvl(l.locks,0)||chr(10)||
'Archiver      : '||i.archiver||chr(10)||'Uptime        : '||floor(sysdate-i.
startup_time)||' days(s) '||trunc(24*((sysdate-i.startup_time)-trunc(sysdate-i.
startup_time)))||' hour(s) '||mod(trunc(1440*((sysdate-i.startup_time)-trunc(
sysdate-i.startup_time))),60)||' minute(s) '||mod(trunc(86400*((sysdate-i.
startup_time)-trunc(sysdate-i.startup_time))),60)||' seconds'uptime from sys.
gv_$instance i,(select inst_id,count(*)sessions from sys.gv$session where nvl(username
,'BACKGROUND')not in('SYS','SYSTEM','BACKGROUND')group by inst_id)s,(select inst_id,
count(*)process from(select p.inst_id,s.username,s.process from gv$session s,
gv$process p where s.inst_id=p.inst_id and s.paddr=p.addr)where nvl(username,
'BACKGROUND')not in('SYS','SYSTEM','BACKGROUND')group by inst_id)p,(select inst_id,
count(*)locks from sys.gv$locked_object group by inst_id)l where s.inst_id(+)=i.
instance_number and p.inst_id(+)=i.instance_number and l.inst_id(+)=i.
instance_number;
