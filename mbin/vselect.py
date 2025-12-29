#!/usr/bin/env python3

from simple_term_menu import TerminalMenu

from sys import argv
from os.path import expanduser, exists

# from os import kill
# import signal


# def argv_to_array():
#     return [x for x in argv[1:]]
#

# def send_signal(pid):
#     kill(int(pid), signal.SIGALRM)
#     return ""
#
#

# todo compute shortcut with 1 2 3

def main():
    # print(["[%s] %s"%x for x in enumerate(argv[1:])])
    # exit()
    bat_opt = ""
    if exists("/tmp/.rv"):
        bat_opt = " --theme=GitHub "
    terminal_menu = TerminalMenu(["[%s] %s" % (x[0], expanduser(x[1])) for x in enumerate(argv[1:])],
            preview_command="bat --color=always " + bat_opt + " {}",
            # preview_command="bat --color=always {}",
            preview_size=0.75)
    menu_entry_index = terminal_menu.show()
    print(expanduser(argv[1 + menu_entry_index]))


if __name__ == "__main__":
    if len(argv) == 2:
        print(argv[1])
    else:
        main()

#    https://ops.tips/blog/macos-pid-absolute-path-and-procfs-exploration/
#    https://github.com/IngoMeyer441/simple-term-menu
