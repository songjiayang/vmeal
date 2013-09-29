#!/bin/sh
#设置运行delayed_job的路径
#nohup ./delay_job_email.sh &
set_path="cd ."

case "$1" in
  start)
    echo -n "Starting delayed_job: "
      su - rails -c "$set_path; RAILS_ENV=production script/delayed_job start" >> log/delayed_job.log 2>&1
    echo "done."
  ;;
  stop)
    echo -n "Stopping sphinx: "
    su - rails -c "$set_path; RAILS_ENV=production script/delayed_job stop" >> log/delayed_job.log 2>&1
    echo "done."
  ;;
  *)
    N=/etc/init.d/delayed_job
    echo "Usage: $N {start|stop}" >&2
    exit 1
  ;;
esac

exit 0
