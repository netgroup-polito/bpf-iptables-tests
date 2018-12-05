# use a clean instance of polycubed to run each test
RELAUNCH_POLYCUBED=true
polycubed="sudo polycubed -a 0.0.0.0 -l off" #todo log off

function initialize_pcn_iptables {
  bpf-iptables-init-xdp
    # $HOME/polycube/services/pcn-iptables/iptables-compatibility/iptables-init.sh
}

# Check if polycubed rest server is responding
function polycubed_is_responding {
  ret=$(polycubectl ? > /dev/null)
  ret=$(echo $?)
  echo $ret
}

# Relaunch polycubed, if deamon is not running
function polycubed_relaunch_if_not_running {
  alive=$(ps -el | grep polycubed)
  if [ -z "$alive" ]; then
    echo "polycubed not running ..."
    echo "relaunching polycubed ..."
    $polycubed >> /dev/null 2>&1 &
  fi
}

# Launch polycubed, and wait until it becomes responsive
function launch_and_wait_polycubed_is_responding {
  if $RELAUNCH_POLYCUBED; then
    echo "starting polycubed ..."
    $polycubed >> /dev/null 2>&1 &
  else
    polycubed_alive=$(ps -el | grep polycubed)
    if [ -z "$polycubed_alive" ]; then
      echo "polycubed not running ..."
      echo "relaunching polycubed ..."
      $polycubed >> /dev/null 2>&1 &
    fi
  fi

  done=0
  i=0
  while : ; do
    sleep 1
    responding=$(polycubed_is_responding)
    if [[ $responding -eq 0 ]]; then
      done=1
    else
      polycubed_relaunch_if_not_running
    fi
    i=$((i+1))
    if [ "$done" -ne 0 ]; then
      if $RELAUNCH_POLYCUBED; then
        echo "starting polycubed in $i seconds"
      else
        if [ -z "$polycubed_alive" ]; then
          echo "relaunching polycubed in $i seconds"
        fi
      fi
        break
    fi
  done
}

# Kill polycubed, and wait all services to be unloaded and process to be completely killed
function polycubed_kill_and_wait {
  echo "killing polycubed ..."
  sudo pkill polycubed >> /dev/null

  done=0
  i=0
  while : ; do
    sleep 1
    alive=$(ps -el | grep polycubed)
    if [ -z "$alive" ]; then
      done=1
    fi

    i=$((i+1))

    if [ "$done" -ne 0 ]; then
        echo "killing polycubed in $i seconds"
        break
    fi
  done
}

function launch_pcn_iptables {
    export PATH=$PATH:/home/polycube/go/bin
    export PATH=$PATH:/home/polycube/polycube/services/pcn-iptables/scripts
    launch_and_wait_polycubed_is_responding
    initialize_pcn_iptables
}
