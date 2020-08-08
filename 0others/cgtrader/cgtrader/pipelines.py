import scrapy
from scrapy.pipelines.files import FilesPipeline

class CgtraderPipeline(FilesPipeline):

    def get_media_requests(self, item, info):   

        for url,name in zip(item["file_urls"],item["file_names"]):    

            yield scrapy.Request(url, meta={'title': f'{name}'})

    def file_path(self, request, response=None, info=None):

        return f"{request.meta['title']}" 