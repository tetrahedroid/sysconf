install: root nis mdns avahi nfs autofs nis ssh loadreporter python gromacs
	echo Done!


activate.%:
	systemctl enable $*
	systemctl start $*


root:
	passwd


mdns:
	./appender.sh /etc/nsswitch.conf "^hosts" "mdns4_minimal[NOTFOUND=return]"
	./appender.sh /etc/nsswitch.conf "^hosts" dns
	./appender.sh /etc/nsswitch.conf "^hosts" mdns


avahi:
	apt install avahi-daemon
	make activate.avahi-daemon


nfs:
	apt install nfs


autofs:
	apt install autofs
	echo "/net -hosts" >> /etc/auto.master
	make activate.autofs
	cd / && ln -s /net/jukebox4.local/u2 /u


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


loadreporter:
	cd /tmp && git clone https://github.com/vitroid/loadreporter.git
	cd /tmp/loadreporter && make install


python:
	apt install python3 python3-pip
	pip install genice2 pipenv


gromacs:
	apt install gromacs
