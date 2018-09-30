        require 'rubygems'
        require 'sitemap_generator'

        # Set the host name for URL creation
        SitemapGenerator::Sitemap.default_host = Settings.sitemap.host
        SitemapGenerator::Sitemap.sitemaps_path = 'shared/'

        SitemapGenerator::Sitemap.create do

        end
        SitemapGenerator::Sitemap.ping_search_engines
