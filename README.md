# Static Website Development Toys: suite

All the stuff that make front end web development fun, in one simple toolkit.

### Suite _gives you…_
* Coffee Script
* SASS
* HAML
* Sprockets
* Javascript & CSS minifying
* Development Server
* Scaffolding
* Happiness

### Suite _does not_
* Have routes
* Access a database
* Give you a controller
* Get fat models
* Cache
* Cook eggs
* Make you want to kill yourself

## Table of Contents

   * [1 How It Works](#section_1)
   * [2 Installation](#section_2)
   * [3 Usage](#section_3)
      * [3.1 suite project](#section_3.1)
      * [3.2 suite server](#section_3.2)
      * [3.3 suite build](#section_3.3)
   * [4 Creating a Site](#section_4)
      * [4.1 Content](#section_4.1)
      * [4.2 Layouts](#section_4.2)
      * [4.3 Assets](#section_4.3)
      * [4.4 Images](#section_4.4)
      * [4.5 Pages (content.yml)](#section_4.5)
      * [4.6 Settings (suite.yml)](#section_4.6)
   * [5 About](#section_5)
   * [6 Development](#section_6)
      * [6.1 Version History](#section_6.1)
      * [6.2 TODO](#section_6.2)
      * [6.3 License](#section_6.3)

## <a name="section_1"></a> 1 How It Works
Suite works on a per project basis. Each suite project has a directory structure that it knows and loves. When you’re in a project directory you can either run the `suite server` for the development server, or build a compiled site with `suite build`.

## <a name="section_2"></a> 2 Installation
Suite is available via rubygems `gem install suite`

Ruby 1.9 or greater is required. If you need to upgrade your ruby version I recommend using [rbenv](https://github.com/sstephenson/rbenv/) and [ruby-build](https://github.com/sstephenson/ruby-build)

## <a name="section_3"></a> 3 Usage
There are only three things you can do with the suite command: Create a new project, run the development server, or build a compiled site.

### <a name="section_3.1"></a> 3.1 suite project
Create a new project. You will be prompted for configuration settings, which will be used to write your config/suite.yml file. All of these settings are configurable later.

`suite project my_awesome_new_project`

#### Configuration prompts
These configuration settings apply to the build phase only

* __Compress JavaScript?__ Compress javascript using the YUI Compressor
* __Shorten JavaScript Variables?__ Shorten your javascript variables
* __Compress CSS?__ Compress stylesheets using the YUI Compressor
* __Will you serve assets from a CDN?__ Will you be serving JS & CSS from another server
* __CDN Host and path__ The full path where JS & CSS will be located

These configuration settings aren’t build phase specific

* __Create git repo?__ Create a git repo in your new project dir, and a .gitignore file

### <a name="section_3.2"></a> 3.2 suite server
Runs a development server that will render content and assets on the fly.

`suite server`

If you’re not in the root folder of a Suite project an exception will be raised, otherwise expect to see something like this

`[59769:INFO] 2012-03-06 15:59:34 :: Starting server on 0.0.0.0:9000 in development mode. Watch out for stones.`

In the background, this is a Goliath server which handles requests for both content and assets - compiling them on the fly. You should not need to restart your server when changing content, javascript or stylesheets - but you _will_ need to restart it if you change your `config/suite.yml` or `config/content.yml` files.

### <a name="section_3.3"></a> 3.3 suite build
Building a site does a few things.

1. Renders  HAML partials into the appropriate html files
2. Renders SASS and CoffeeScript to CSS and JavaScript
3. Compress / minify CSS and JavaScript if your config says to
4. Cachebust your CSS and JavaScript

The command takes an optional view name, and will default to the desktop view. For more information read the section on views further on.

__Build the default 'desktop' view__

`suite build` 

__Build the 'mobile' view__

`suite build mobile`


#### A note on cachebusting
To prevent the caching of assets on the client side, the filenames of the assets are the MD5 checksum of their content. As long as you’ve used the correct include helpers in your HAML markup, your html will be rendered with the correct paths.

`<script type="text/javascript" src="/assets/c1aba2692680cbc9e958451badaa989a.js"></script>`

## <a name="section_4"></a> 4 Creating a Site
The content of your site is located in the `content` folder, while the assets live in the `assets` folder (surprised?).

### <a name="section_4.1"></a> 4.1 Content

__All content files have the extension .html.haml__

If you’ve never dealt with HAML before, I’d recommend checking out the [tutorial](http://haml-lang.com/tutorial.html) first.

Each page in your site is made up of one or more content partials (wrapped in a layout). How these pages are defined is explain further on.

All content partials are stored in the `content` directory. You’re allowed to have nested folders galore, so don’t feel stuck to a flat directory structure.

The default files you get are `content/homepage.html.haml` and `content/info.html.haml`. If you have a look at them, you’ll notice they’re pretty plain and boring – it’s up to you to create exciting markup!

__See content.yml below for information about how pages are defined__

### <a name="section_4.2"></a> 4.2 Layouts

Layouts are stored in the `content/layouts` folder, although this isn’t enforced in the `config/content.yml` file. The default layout is `content/layouts/application.html.haml` and is based on the HTML5 boilerplate markup.

The content of the page is rendered and inserted with the `yield` command, see the default layout for an example.

### <a name="section_4.3"></a> 4.3 Assets

#### Stylesheets and JavaScripts

If you want to include an asset as part of your site you need to use the asset helpers `javascript_include_tag` and `stylesheet_link_tag`. Rails developers will be familiar with the method names.

Both tags take the path to the asset, relative to their asset folder (`assets/javascripts` for js and `assets/stylesheets` for CSS), and do __not__ require their extension.

To load `assets/javascripts/application.js` you’d call `javascript_include_tag "application"`

To load `assets/stylesheets/styles.css.scss` you’d call `stylesheet_link_tag "styles"`

#### Sprockets

Internally, Suite uses [sprockets](https://https://github.com/sstephenson/sprockets/) to handle the rendering of CSS and JavaScript assets. This give you a few key features.

_Firstly,_ you can use coffeescript or sass without any headaches. If you want a new coffeescript file that renders to javascript, just create `assets/javascripts/my_script.js.coffee` and if you want a new sass file `assets/stylesheets/my_styles.css.scss`.

_Secondly,_ you can use the `//= require "file_name"` syntax to include other files. This is a killer feature of sprockets. No longer do you have to worry about multiple files and then bundling them for release – simply use your application.js as a container file for all the separate classes you need. Suite will smartly create `<script />` tags for all the required assets during development, and then bundle and minify them during the build process.

__I’d recommend reading the sprockets homepage, it’s a great bit of software.__

#### External Javascript and CSS

To include an external JS or CSS asset, use the standard HAML / HTML – no funny business here.


### <a name="section_4.4"></a> 4.4 Images

Store images in the `assets/images/` folder. To render an image in your content, use the `image_tag` helper. Just send through the path to the file relative to the `assets/images/` directory, and an optional array of attributes.

`image_tag "raptor.jpg"` becomes `<img src="assets/images/raptor.jpg" />`

`image_tag "dinosaurs/raptor.jpg"` becomes `<img src="assets/images/dinosaurs/raptor.jpg" />`

`image_tag "cats/mog.png", class: ["cat", "thumbnail"], id: "my_kitteh"` becomes `<img src="assets/images/cats/mog.png" class="cat thumbnail" id="my_kitteh" />`

All images will be copied to the `assets/images` folder in your build directory when you run the build command. Images created with the `image_tag` will be updated with the correct paths for your cdn / asset host if you have one set (_see: 4.6 Settings_).

### <a name="section_4.5"></a> 4.5 Pages (content.yml)

__All content files have the extension .html.haml__

Your site’s pages are defined in the files `config/content.yml`. Each page consists of a layout (if no layout is defined, it uses the default layout).

The content.yml file can be used to define several views for your site. You might have one view for the desktop browser, and another for mobile (don’t start a responsive design argument right now) – or you might just have the one view.

Here’s the default content.yml file you’ll get when you create a new project:

	desktop:
    	layout: "layouts/application"
    	pages:
        	index:
            	content: ["homepage", "info"]`

The root element is the name of the view, in this case 'desktop'. Inside that we have two elements, a layout element that defines the location of the layout that pages are wrapped in and a pages element that defines the pages the site will have.

#### Layouts

This looks for a file inside of the content folder. In this case, the file is `content/layouts/application.html.haml`.

A layout file must have a call to `yield` where the content is required in the layout.

#### Pages and Content

The default site only has one page, the index page. Inside a page element you have a content element, which has an array of content partials. The partials should be created in the `content/` directory. This means the default partials can be found at `content/homepage.html.haml` and `content/info.html.haml`. You can add as many items into each pages’ content array as you’d like.

You can also have a custom layout declared on any page, for those ‘irregular’ pages.

			payment:
				layout: "layouts/payment"
				content: ["payment/form", "payment/sidebar"]

#### Nested Pages

You’re not limited to a flat directory structure. You can also nest pages.

		pages:
			about:
				content: ["about/navigation", "about/intro"] #optional content
				the_team:
					content: ["about/navigation", "about/team"]
				the_company:
					content: ["about/navigation", "about/company"]
				

In this case, we end up with three valid urls: `about/`, `about/the_team/`, and `about/the_company/`. If we didn’t have a content element in the root of the 'about' element, it would still be valid - we just wouldn’t get the `about/` page.

__Note: If you change your content.yml file, you will need to restart the development server__

#### Site Views

To create multiple views of your site, simply add a new root element to `content.yml`. Here’s an example with two versions, the desktop version and a mobile version, which you would build with `suite build mobile`.

	desktop:
	    layout: "layouts/desktop"
	    pages:
	        index:
	            content: ["homepage", "info"]
	        contact:
	        	content: ["contact-us"]
	mobile:
	    layout: "layouts/mobile"
	    pages:
	        index:
	            content: ["homepage", "find-us", "add-to-homescreen"]
	        contact:
	        	content: ["link-to-maps"]


### <a name="section_4.6"></a> 4.6 Settings (suite.yml)

Your build config file is `config/suite.yml`, and contains settings used during build. This is the file that’s created for you depending on the responses you give when you run the `suite project` command.

#### Compression

Please see the [YUI Compressor Documentation](http://developer.­yahoo.­com/­yui/­compressor/­) to learn why you might or might not want to use these settings.

* __compress_javascript__ Should javascript assets be minified?
* __compress_css__ Should stylesheet assets be compressed?
* __shorten_javascript_variables__ Should local javascript variables be shortened?

#### CDN / Asset Server

If you’re serving up your assets from a different server to the server where your pages will be hosted, you need to set the `asset_host` variable in your suite.yml. This needs to be a fully qualified domain name, and an optional path.

`http://s3.amazonaws.com/my-bucket-name` and `http://something.cloudfront.net` are both good.

When you build your site, in the build folder for your site view you’ll get two folders, `site` and `cdn`. Your html files and htaccess will be in `site` and in `cdn` you’ll find your javascripts, stylesheets and images folders. Just upload these to your asset host / cdn and you’re good to go.

If you’ve used the `stylesheet_link_tag` and `javascript_include_tag` view helpers (which you should have), then they will have rendered the correct location to your assets in your html files, such as:

`http://s3.amazonaws.com/my-bucket-name/javascripts/c1aba2692680cbc9e958451badaa989a.js`

## <a name="section_5"></a> 5 About

From the very beginning, this toolkit has been designed from the ground up to scratch my own itch while developing a non dynamic site. I wanted SASS and CoffeeScript so I had them running watching for changes in two windows. I wanted HAML for my content, so I hacked together a build script and created my own way of organising partials. Eventually running sass, coffeescript and a build script became enough of a hindrance that I started to think bigger, and Suite was born.

At this point, I haven’t finished my original project so there are plenty of new features that I’ll be building when I come to need them.

## <a name="section_6"></a> 6 Development
I’m still new at Ruby so I may have done things in a round-about fashion. If you want to add something in, or clean something up, feel free to do so and make a pull request, or file a [new issue](https://github.com/snikch/suite/issues).

### <a name="section_6.1"></a> 6.1 Development

__0.1.3__ (March 11, 2012)

* Handle root dir icon assets, e.g.favicon, apple-touch-icon(.*)

__0.1.2__ (March 9, 2012)

* Performance of dev server increased 3x

__0.1.1__ (March 7, 2012)

* Cleaned up default template cruft

__0.1.0__ (March 7, 2012)

* Initial public release.


### <a name="section_6.2"></a> 6.2 TODO

#### To Do / Roadmap

* build renders htaccess that redirects requests for .html files when no .html is added
* Handle favicons, apple touch images automatically
* Handle 404’s
* Broken assets insert exception information into the page including them
* Javascripts / Stylesheets can be inserted into the head, or body end, from any partial
* Deal with 500 errors in the server
* Nicer default style / messages
* Server reloads config files when they’re changed

### <a name="section_6.3"></a> 6.3 License
(The MIT license)

Copyright (c) 2011 Mal Curtis

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

