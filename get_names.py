#!/usr/bin/env python3
#skripta koja dohvaca sve dionice sa zagrebacke burze i sprema ih u txt file

from selenium import webdriver
from bs4 import BeautifulSoup

def main():
    print("Azuriranje liste dionica:")
    
    print("     dohvacam listu..")
    driver = webdriver.PhantomJS()
    driver.get("http://zse.hr/default.aspx?id=9978")

    html = driver.page_source
    soup = BeautifulSoup(html, "html.parser")

    table = soup.find('table', attrs = { "id" : "dnevna_trgovanja"})
    
    print("     zapisujem u datoteku..")
    names_list = []
    f = open('list_full.txt', 'w')

    table = table.find_all('tr')[1:]
    for row in table:
        names_list.append([val.contents[0] for val in row.find_all('a')])


    for name in names_list:
        f.write("".join(name) + "\n")
    f.close()

    print("Gotovo!")

if __name__ == "__main__":
    main()
