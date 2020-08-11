from scrapy import Request
from scrapy.spiders import CrawlSpider, Rule
from scrapy.linkextractors import LinkExtractor

from ..items import CgtraderItem
import json

import sys

counter_page = 5


class CgtraderSpider(CrawlSpider):

    name = "cgtrader"

    counter_login = 1
    counter_page = 0

    email = []
    email_counter = 0

    password = []
    password_counter = 0

    download_link = "https://www.cgtrader.com/"
    
    link = "https://www.cgtrader.com/free-3d-models/swap_category?page=swap_page"

    def __init__(self, config_file = None, *args, **kwargs):                    
        super(CgtraderSpider, self).__init__(*args, **kwargs)  

        file = open("login.txt","r")

        links = []

        while True:
            email = file.readline()
            if not email:
                break
            self.email.append(email.strip("\n"))
            passs = file.readline()
            self.password.append(passs.strip("\n"))        
          

        file = open("input.txt","r")

        links = []

        for catg in file.readlines():
            temp = self.link
            temp = temp.replace("swap_category",catg)
            links.append(temp)
    
        self._url_list = links

        file.close()                                                             

    def start_requests(self):   
        self.counter_login = counter_page

        yield Request(url= "https://www.cgtrader.com/",callback=self.main)
    
    def main(self,response):

        if self.email_counter < len(self.email):
            data = {"user":{"login":f"{self.email[self.email_counter]}","password":f"{self.password[self.password_counter]}","remember_me":True}}
            self.email_counter +=1
            self.password_counter  +=1

            data = json.dumps(data).encode('utf-8')

            header = {
                    'authority': 'www.cgtrader.com',
                    'pragma': 'no-cache',
                    'x-newrelic-id': 'VwYCU1ZUGwEAU1hWBQM=' ,
                    'x-csrf-token': response.css("meta[name='csrf-token']::attr(content)").extract_first(),
                    'user-agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.116 Safari/537.36',
                    'content-type': 'application/json;charset=UTF-8',
                    'accept': 'application/json, text/plain, */*',
                    'sec-fetch-dest': 'empty',
                    'x-requested-with': 'XMLHttpRequest',
                    'origin': 'https://www.cgtrader.com',
                    'sec-fetch-site': 'same-origin',
                    'sec-fetch-mode': 'cors',
                    'referer': 'https://www.cgtrader.com/',
                    'accept-language': 'en-US,en;q=0.9',
                    'cookie': 'ahoy_visitor=aa8843ed-ac31-4280-b684-82777b213e8e; _cgtrader_cookies_check=true; _cgtrader_f1r57v=2020-02-21+07%3A56%3A28+UTC; _cgtrader_673cc0=36; _cgtrader_auid99=02f7ee66-72ac-402e-b129-108b909c4c57; visid_incap_1799077=wBbIVBYUSACpbfpqAog8nCyNT14AAAAAQUIPAAAAAAAq+kjxtbZOsHgEfbrGw9VK; nlbi_1799077=7BuUYoEZ0Tv9UXE9nyifUQAAAABmjF9O0jym9RHjjruwsTMZ; _gcl_au=1.1.1667865243.1582271791; _ga=GA1.2.971192581.1582271794; _gid=GA1.2.708230736.1582271794; _hjid=1ad631bd-1446-47e2-affe-08ccd36413f9; _fbp=fb.1.1582271794719.1588156235; hubspotutk=d8b0b686a8164b48a8cb12537d897429; __hssrc=1; __zlcmid=wrivg39Sh2Zh80; ahoy_visit=47a61ecd-004e-49a1-a946-6511278f7dc0; _cgtrader_uuid=33095072; _cgtrader_389537=120; screen_width=1850; _cgtrader_cpsa48=true; incap_ses_1183_1799077=mOPIAbUnsiMbLtkswNxqEHj6T14AAAAAPUZ7NWGFTdH1yqkjimLXGg==; _dc_gtm_UA-21829154-5=1; __hstc=51431414.d8b0b686a8164b48a8cb12537d897429.1582271797846.1582299771072.1582305403360.4; _cgtrader_98e316=%04%08%7B%09%3A%0Fpage_viewsid%3A%0Bvisitsi%08%3A%0Ftotal_timei%02R%83%3A%0Flast_visitl%2B%07%7E%10P%5E; _gat_UA-21829154-5=1; __hssc=51431414.2.1582305403360; _secure_cgtrader_session=NGh2aTNSWUVoNnJPeituWjd4VzRUTDVTdHZTR014UzgwVEJqNEZEYlEzS1VVd0lscEdJR0NteVJjUC9ZLzIxbW1BR1RDTjM3OXA1aXkxS2pPeFZsbGZQM0NGY3BjZlVmdS9pTmtNTVd0eXJrdXBMRlRFb2JwQUI0SjMxQ0t1dmNpKzFXdzNTU09mb1M2aFUvdGhEYldNcStPRXhrNFh2TmE4ekt5ZklhaHM5NnZpZlBycUZUK1dUMTIwM1VOR1Q0LS0yNzZCeUsrbThYT2ZQWWlzWWpZbmxRPT0%3D--28607956b0e8570f96faf666578a0db5dc79d991'
                    }

            yield Request(url='https://www.cgtrader.com/users/2fa-or-login',
                            method="POST",headers = header ,body=data)  

            for url in self._url_list:
                url = url.replace("swap_page",f"{self.counter_page + 1}")                                              
                yield Request(url = url, callback = self.parse)
   
    def parse(self, response):

        links = response.css(".content-box__link:nth-child(2)::attr(href)").extract()

        for url in links:                                              
            yield Request(url = url, callback = self.image_page)

        
        next_page = response.css("a[data-track-name='Next']::attr(href)").extract_first()

        if next_page:
            if self.counter_login:                                                          
                yield Request(url = next_page, callback = self.parse)
                self.counter_page +=1
                self.counter_login -= 1
            else:
                self.start_requests()
    
    def image_page(self, response):

        product = CgtraderItem()

        product["url"] = response.url

        product["title"] = response.css("h1[itemprop='name']::text").extract_first()

        product["images"] = response.css(".image--3XEDb::attr(src)").extract_first()


        product["Publishdate"] = response.css(".short-product-details~ .card--flat+ .card--flat .l-inner ul li:nth-child(1) span::text").extract_first()
        
        product["ModelID"] = response.css(".short-product-details~ .card--flat+ .card--flat .l-inner ul li:nth-child(2) span::text").extract_first()


        product["Animated"] = response.css(".short-product-details~ .card--flat+ .card--flat .l-inner ul li:nth-child(3) i[class='fal svg-inline--fa fa-times-circle is-red is-not-spaced right-column']").extract_first()
        if product["Animated"]:
            product["Animated"] = "NO"
        else:
            product["Animated"] = "Yes"


        product["Rigged"] = response.css(".short-product-details~ .card--flat+ .card--flat .l-inner ul li:nth-child(4) i[class='fal svg-inline--fa fa-times-circle is-red is-not-spaced right-column']").extract_first()
        if product["Rigged"]:
            product["Rigged"] = "NO"
        else:
            product["Rigged"] = "Yes"

        product["VR_AR_Low_poly"] = response.css(".short-product-details~ .card--flat+ .card--flat .l-inner ul li:nth-child(5) i[class='fal svg-inline--fa fa-times-circle is-red is-not-spaced right-column']").extract_first()
        if product["VR_AR_Low_poly"]:
            product["VR_AR_Low_poly"] = "NO"
        else:
            product["VR_AR_Low_poly"] = "Yes"

        product["PBR"] = response.css(".short-product-details~ .card--flat+ .card--flat .l-inner ul li:nth-child(6) i[class='fal svg-inline--fa fa-times-circle is-red is-not-spaced right-column']").extract_first()
        if product["PBR"]:
            product["PBR"] = "NO"
        else:
            product["PBR"] = "Yes"
            
        product["Geometry"] = response.css(".short-product-details~ .card--flat+ .card--flat .l-inner ul li:nth-child(7) span::text").extract_first()

        product["Polygons"] = response.css(".short-product-details~ .card--flat+ .card--flat .l-inner ul li:nth-child(8) span::text").extract_first()

        product["Vertices"] = response.css(".short-product-details~ .card--flat+ .card--flat .l-inner ul li:nth-child(9) span::text").extract_first()

        product["Textures"] = response.css(".short-product-details~ .card--flat+ .card--flat .l-inner ul li:nth-child(10) i[class='fal svg-inline--fa fa-times-circle is-red is-not-spaced right-column']").extract_first()
        if product["Textures"]:
            product["Textures"] = "NO"
        else:
            product["Textures"] = "Yes"

        product["Materials"] = response.css(".short-product-details~ .card--flat+ .card--flat .l-inner ul li:nth-child(11) i[class='fal svg-inline--fa fa-times-circle is-red is-not-spaced right-column']").extract_first()
        if product["Materials"]:
            product["Materials"] = "NO"
        else:
            product["Materials"] = "Yes"

        product["UVMapping"] = response.css(".short-product-details~ .card--flat+ .card--flat .l-inner ul li:nth-child(12) i[class='fal svg-inline--fa fa-times-circle is-red is-not-spaced right-column']").extract_first()
        if product["UVMapping"]:
            product["UVMapping"] = "NO"
        else:
            product["UVMapping"] = "Yes"
            
        product["UnwrappedUVs"] = response.css(".short-product-details~ .card--flat+ .card--flat .l-inner ul li:nth-child(13) span::text").extract_first() 

        product["Pluginssed"] = response.css(".short-product-details~ .card--flat+ .card--flat .l-inner ul li:nth-child(14) i[class='fal svg-inline--fa fa-times-circle is-red is-not-spaced right-column']").extract_first()
        if product["Pluginssed"]:
            product["Pluginssed"] = "NO"
        else:
            product["Pluginssed"] = "Yes"

        download_img = response.css(".btn.btn-secondary.btn-block::attr(href)").extract_first()

                                            
        yield response.follow(url = download_img, meta={'product':product},callback = self.download_img_page)


    def download_img_page(self,response):

        product = response.meta["product"]


        product["file_urls"]  = response.css(".js-auth-control.js-free-download::attr(href)").extract()
        for count in range(len(product["file_urls"])):
            temp = self.download_link
            product["file_urls"][count] = temp + product["file_urls"][count] 

        product["file_names"]  = response.css(".details-box__list li::text").extract()

        yield product

        
