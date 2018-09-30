# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(ckeditor/config.js)
Rails.application.config.assets.precompile += 
	%w( admin.js admin.css 
		dashboard.css introjs.css 
		modernizr/modernizr.js 
		dashboard_v2.js dashboard_v2.css 
		registration.css registration.js 
		legacy.css common.css
		stripe.js )
