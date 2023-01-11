install: FIRSTOFALL root sudoers nis mdns avahi nfs autofs nis ssh loadreporter python gromacs
	echo Done!

# そもそもmakeがないので、最初にmakeをインストールすべし。
FIRSTOFALL:
	echo git clone https://github.com/tetrahedroid/sysconf.git
	echo apt install make

activate.%:
	systemctl enable $*
	systemctl stop $*
	systemctl start $*

root:
	passwd

sudoers:
	install -m 0644 sudoers.d/theochem /etc/sudoers.d/
	echo MANUAL ACTION REQUIRED: Remove group 1000 by using vigr

mdns:
	./appender.sh /etc/nsswitch.conf "^hosts" "mdns4_minimal[NOTFOUND=return]"
	./appender.sh /etc/nsswitch.conf "^hosts" dns
	./appender.sh /etc/nsswitch.conf "^hosts" mdns

avahi:
	apt install avahi-daemon
	make activate.avahi-daemon

nfs:
	apt install nfs-common

autofs:
	apt install autofs
	mkdir /net
	echo "/net -hosts" >> /etc/auto.master
	make activate.autofs
	ln -s /net/jukebox4.local/u2 /u
	ln -s /net/jukebox1.local/r3 /
	ln -s /net/jukebox2.local/r4 /
	ln -s /net/jukebox3.local/r6 /
	ln -s /net/jukebox4.local/r5 /
	ln -s /net/jukebox5.local/r7 /


nis:
	apt install yp-tools
	echo theochem > /etc/defaultdomain
	echo "domain theochem broadcast" >> /etc/yp.conf
	./appender.sh /etc/nsswitch.conf "^passwd" nis
	./appender.sh /etc/nsswitch.conf "^group" nis
	./appender.sh /etc/nsswitch.conf "^shadow" nis
	./appender.sh /etc/nsswitch.conf "^hosts" nis
	make activate.ypbind

ssh:
	apt install openssh-server
	grep "^HostKeyAlgorithms" /etc/ssh/sshd_config || ( echo "HostKeyAlgorithms +ssh-rsa" >> /etc/ssh/sshd_config )
	grep "^PubkeyAcceptedKeyTypes" /etc/ssh/sshd_config || ( echo "PubkeyAcceptedKeyTypes +ssh-rsa" >> /etc/ssh/sshd_config )

loadreporter: python
	cd /tmp && git clone https://github.com/vitroid/loadreporter.git
	cd /tmp/loadreporter && make install

python:
	apt install python3 python3-pip
	pip install numpy
	pip install genice2 pipenv

gromacs: python
	apt install gromacs


extra: cuda

cuda:
	apt -y install nvidia-cuda-toolkit
	ubuntu-drivers install
	# reboot required.

# 大学のVLANへの接続申請
