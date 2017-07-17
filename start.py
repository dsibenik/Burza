#!/usr/bin/env python3

import sys, os
import subprocess
import update_data

def wait_key():
    ''' Wait for a key press on the console and return it. '''
    result = None
    if os.name == 'nt':
        import msvcrt
        result = msvcrt.getch()
        os.system('cls')
    else:
        import termios
        fd = sys.stdin.fileno()

        oldterm = termios.tcgetattr(fd)
        newattr = termios.tcgetattr(fd)
        newattr[3] = newattr[3] & ~termios.ICANON & ~termios.ECHO
        termios.tcsetattr(fd, termios.TCSANOW, newattr)

        try:
            result = sys.stdin.read(1)
        except IOError:
            pass
        finally:
            termios.tcsetattr(fd, termios.TCSAFLUSH, oldterm)
        os.system('clear')
    return result

class case:
    def update_list_full(self):
        import get_names
        get_names.main()
        return

    def update_list_work(self):
        while(1):
            lst_full = update_data.citaj_simbole("list_full.txt")
            j = 1
            for i in lst_full:
                print( j, i )
                j += 1
            print("------------------------------------------------------------")
            num = input('Upisite broj simbola koji zelite dodati (0 za izlaz): ')
                    
            if num not in [ str(x) for x in list(range(j)) ]:
                print("Kriva vrijednost!")
                print("Any) Upisi drugu")
                print("0) Izlaz")
                if( wait_key() == str(0) ):
                    return
            elif num == "0":
                return
            else:
                f = open("list_work.txt", "a")
                f.write(lst_full[int(num)-1] + "\n")
                f.close()
                print("Dodano", lst_full[int(num)-1])
                print("Any) Dodaj jos")
                print("0) Izlaz")
                if( wait_key() == str(0) ):
                    return

        return

    def clear_list_work(self):
        print("Jeste li sigurni da zelite obrisati listu (d/n) ?")
        if( wait_key() == "d" ):
            f = open("list_work.txt", "w")
            f.close()
            print("Lista izbrisana!")
        return

    def update_data_work(self):
        ls_wrk = update_data.citaj_simbole("list_work.txt")
        if len(ls_wrk) == 0:
            print("Lista je prazna!")
            return
        update_data.get_data(ls_wrk)
        return

    def get_returns_mon(self):
        print("Racunam..")
        subprocess.call ("./returns_mon.R")
        print("Mjesecni povrati:")
        [print(i) for i in update_data.citaj_simbole("output.txt")]
        return

    def print_list_work(self):
        print("Radna lista dionica:")
        [print(i) for i in update_data.citaj_simbole("list_work.txt") ]
        return


def main():    
    print("BURZA ########################")
    legend = { 
        "1": "print_list_work",
        "2":"get_returns_mon",
        "6":"update_list_work",
        "7":"clear_list_work",
        "8":"update_data_work",
        "9":"update_list_full" }

    while(1):
        print("")
        print("...................................")

        print("1) Prikaz radne liste dionica")
        print("2) Racunanje mjesecnih povrata radne liste")
        
        print("6) Izmjena radne liste dionica")
        print("7) Brisanje radne liste dionica")
        print("8) Azuriranje podataka radne liste")
        print("9) Azuriranje potpune liste dionica")

        print("0) Izlaz")

        print("Upisite broj zeljene akcije:") 
        action = wait_key()

        if action not in [ str(x) for x in [1,2,6,7,8,9,0] ]:
            print("Kriva vrijednost!")
        elif action == "0":
            return
        else:
            tmp = case()
            getattr( tmp, legend[action] )()


if __name__ == "__main__":
    main()
