# Harbinger
A python tool that simplifies automating tasks across multiple servers.

## Installation
```text
pip install harbinger
```

## Example
```python
#!/usr/bin/env python3
import harbinger
import json

ssh = harbinger.Client()

host1 = {'address': '1.1.1.1', 'username': 'root'}
host2 = {'address': '2.2.2.2', 'username': 'root', 'facts': { 'groups': ['web'] } }

ssh.connect(host1)
ssh.connect(host2)

# or you can feed a list of hosts
# ssh.connect([ host1, host2 ])

# Select only 1.1.1.1 and run a command on the selected server
n = ssh.select(["1.1.1.1"]).cmd("echo selected by address {{ facts.address }}")
print(json.dumps(n, default=lambda o: '<not serializable>', indent=2))

# Select servers in group web and run a command on the selected servers
n = ssh.select_groups(["web"]).cmd("echo selected by group {{ facts.address }}")
print(json.dumps(n, default=lambda o: '<not serializable>', indent=2))

# we're doing multiple selects before running a command here
ssh.select(["1.1.1.1"])
ssh.select_groups(["web"])
n = ssh.cmd("echo selected all by chance {{ facts.address }}")
print(json.dumps(n, default=lambda o: '<not serializable>', indent=2))

# uploading a file
ssh.select(["1.1.1.1"]).put('./test.txt', '/test1.txt')
ssh.select(["1.1.1.1"]).put('./test.j2.txt', '/test2.txt', parse_tpl=True)

# checking if they got uploaded
n = ssh.select(["1.1.1.1"]).cmd("ls -lah /test*.txt; echo ...; cat /test2.txt")
print(n[0]['stdout'])


# download a file
ssh.select(["1.1.1.1"]).get('/etc/hosts', './{{ facts.address }}hosts-file.txt')

ssh.close_all()
```

