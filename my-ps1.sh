# shellcheck shell=bash

my-ps1-aws() {
    if [[ -n "${AWS_PROFILE}" ]]; then
        [[ -n "${AWS_PS1_ALERT}" ]] && [[ "${AWS_PS1_ALERT}" = *"${AWS_PROFILE}"* ]] && K="%K{yellow}"
        echo "%{%F{magenta}${K}%}$AWS_PROFILE%{%f%k%}:"
    fi
}

pre-my-ps1-kube() {
    # Needs to be done here since my-ps1-kube()
    # executes in a subshell, which creates a
    # Glen Quagmire of problems.

    # No config file.  Leave early.
    [[ -z "$KUBECONFIG" ]] && [[ -z $MY_PS1_KUBE ]] && return

    # Make sure the cache file exists.
    if [[ -z "$MY_PS1_KUBE_CACHE" ]] || [[ ! -f "$MY_PS1_KUBE_CACHE" ]]; then
        MY_PS1_KUBE_CACHE=$(mktemp)
    fi

    local kts; kts=$(stat -L -f %m "$KUBECONFIG")
    local cts; cts=$(stat -L -f %m "$MY_PS1_KUBE_CACHE")

    if [[ "$kts" == "$cts" ]]; then
        # Files match, nothing changed so leave early.
        return
    fi

    cp -p "$KUBECONFIG" $MY_PS1_KUBE_CACHE

    local k; k=$(kubectl config view --minify --output 'jsonpath={$.contexts[0].context.cluster}/{$.contexts[0].context.namespace}')

    for m in "${MY_PS1_KUBE_MASKS[@]}"
    do
        k=${k/${m}/}
    done

    MY_PS1_KUBE="$k"
}

my-ps1-kube() {
    [[ -n "$MY_PS1_KUBE" ]] && echo "%{%F{cyan}%}$MY_PS1_KUBE%{%f%}:"
}

my-ps1-git() {
    local color="green"
    local branch

    local isrepo=0
    local d="${PWD}"
    while [[ -n "${d}" ]]; do
        if [[ -d "${d}/.git" ]]; then
            isrepo=1
            break
        fi
        d=${d%/*}
    done

    if [[ "$isrepo" == "1" ]]; then
        # We're in a git repo.  See if there's a branch.
        branch=$(git branch --show-current 2> /dev/null)
        # See if it's dirty or has unpushed commits.
        if [[ -n "$(git status --porcelain)" ]]; then
            color="red"
        else
            # Local is not dirty but are there are unpushed commits?
            [[ -n "$(git cherry -v 2>/dev/null)" ]] && color=yellow
        fi
    fi

    if [[ -n "$branch"  ]]; then
        echo "%{%F{$color}%}$branch%{%f%}:"
    fi
}

my-ps1-dir() {
    echo "%{%F{208}%}%(4~|+/%3~|%~)%{%f%}"
}

my-ps1-head() {
    echo "%(?..%{%B%F{red}%}%? %{%f%b%})"
}

my-ps1-tail() {
    echo "%(!.%{%F{red}%}#%{%f%}.%{%F{yellow}%}>%{%f%})"
}
