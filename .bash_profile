# After /etc/profile, this file is sourced by *login* shells.

# The following sources .profile, which is not automatically sourced when
# .bash_profile is present.
[[ -f ~/.profile ]] && . ~/.profile

# The following sources .bashrc and is recommended by the bash info pages.
#
# .bashrc is only sourced by *interactive non-login* shells (or when bash
# detects it is run remotely with rsh). Depending on bash compilation flags
# (SSH_SOURCE_BASHRC), .bashrc may be sourced when bash detects it is run
# remotely with ssh.
#
# To simplify things, we'll always source .bashrc. We'll guard from double
# sourcing (e.g. when sshing to a server that has bash compiled with
# SSH_SOURCE_BASHRC defined) by testing whether $SOURCED_BASHRC is defined.
[[ -f ~/.bashrc ]] && [[ -z "$SOURCED_BASHRC" ]] && . ~/.bashrc

