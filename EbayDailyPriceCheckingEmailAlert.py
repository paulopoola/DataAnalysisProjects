import csv
import time
import datetime
import requests
import smtplib
from smtplib import SMTP_SSL as SMTP
import pandas as pd
from bs4 import BeautifulSoup

#-----------------Creates the Table--------------#
#header = header = ['Title','Price','Date']
#with open('EbayWebscrappingDataset.csv', 'w', newline='', encoding='UTF8') as f:
#   writer = csv.writer(f)
#   writer.writerow(header)

def Check_Price():
    URL = 'https://www.ebay.com/itm/284171426567'

    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36","Accept-Encoding": "gzip, deflate, br", "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9","DNT":"1", "Connection":"close", "Upgrade-Insecure-Requests": "1"}

    page = requests.get(URL, headers=headers)

    soup1 = BeautifulSoup(page.content, 'html.parser')

    soup2 = BeautifulSoup(soup1.prettify(), 'html.parser')

    title = soup2.find(id='itemTitle').get_text(strip=True)[13:]

    price = soup2.find(id='prcIsum').get_text(strip=True)[4:]
    price = price.replace(',','')
    price = int(float(price))

    today = datetime.date.today()

    header = ['Title','Price','Date']

    data = [title, price, today]

    with open('EbayWebscrappingDataset.csv', 'a+', newline='', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(data)


    if price < 900:
        def send_mail():
            #server = smtplib.SMTP_SSL('smtp.gmail.com',465)
            server = smtplib.SMTP('smtp.gmail.com', 587)
            server.set_debuglevel(1)
            server.ehlo()
            server.starttls()
            server.login('sendermail@mail.com','mailpassword')
##
            subject = "Playstation 5 price drop on ebay"

            body = "Paul, This is the moment we have been waiting for. The Ps5 Price has finally dropped to ${}. Get it here: https://www.ebay.com/itm/284171426567".format(price)

            msg = "Subject: {}\n\n{}".format(subject, body)

            server.sendmail('sendermail@mail.com','recievermail@mail.com', msg)
            server.quit()
            send_mail()
    else:
        print('Price is still above 900')
while True:
    Check_Price()
    time.sleep(86400) # every 24hours
