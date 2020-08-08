# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class CgtraderItem(scrapy.Item):

    title = scrapy.Field()
    images = scrapy.Field()

    Publishdate = scrapy.Field()
    ModelID = scrapy.Field()
    Animated  = scrapy.Field()
    Rigged  = scrapy.Field()
    VR_AR_Low_poly  = scrapy.Field()
    PBR  = scrapy.Field()
    Geometry  = scrapy.Field()
    Polygons  = scrapy.Field()
    Vertices  = scrapy.Field()
    Textures  = scrapy.Field()
    Materials  = scrapy.Field()
    UVMapping  = scrapy.Field()
    UnwrappedUVs  = scrapy.Field()
    Pluginssed = scrapy.Field()
    url = scrapy.Field()

    file_urls = scrapy.Field()
    file_names = scrapy.Field()

    files = scrapy.Field()

    pass
