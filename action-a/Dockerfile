FROM debian:9.5-slim

LABEL "com.github.actions.name"="ShellCheck Runner"
LABEL "com.github.actions.description"="Run Shellcheck."
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="http://github.com/staranto/hello-github-actions"
LABEL "homepage"="http://github.com/actions"
LABEL "maintainer"="Steve Taranto <staranto@gmail.com>"

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
