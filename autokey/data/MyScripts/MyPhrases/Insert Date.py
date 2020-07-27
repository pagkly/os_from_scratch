##https://www.cyberciti.biz/faq/linux-unix-formatting-dates-for-display/
output = system.exec_command("date +'%a_%Y%m%d_%H%M%S'")
keyboard.send_keys(output)