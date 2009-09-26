Page.seed(:permalink) do |p|
  p.permalink = "themehelp"
  p.name = "Theme Help"
  p.content = <<-EOS

h1. Creating custom themes

You can customize each of the pages for your Streetprint created site by creating
a custom theme.  This is recommended only for those comfortable with coding html
and css.

Streetprint allows you to customize the content that appears on each of the pages
as well as the css that is used to style it.  You also have control over a layout
page that is used for all pages.  Your layout template is rendered inside the body
of the HTML page and that pages content is rendered wherever you yeild it in your
layout.  Streetprint uses "liquid":liquid so we need to cover some basic syntax first.

Use double curly braces to evaluate the expression and insert it into the page.

bc. Welcome to {{ site.name }}

Use matched curly braces and percent signs to evaluate the expression without inserting
anything into the page.

bc. {% for item in items %}
  {{ item.title }}
{% endfor %}

For more information on liquid syntax and a list of filters available read "liquid for designers":liquid-designers

*Variables* are used to insert dynamic data like your sites title. Continue reading 
for a list of variables available on each page.

bc. <h1>{{ site.title }}</h1>

In your layout file the variable _yield_ will be set to the pages content. A 
simple layout file may look like this.

bc. <div id='content'>
  <h1>{{ site.title }}</h1>
  {{ yield }}
</div

Whenever *arrays* are made available to you, you can use loops to render them.
For example to display a list of items you could do something like this:
  
bc. <div id='items'>
  <ul>
    {% for item in items %}
      <li>{{item.title}}</li>
    {% endfor %}
  </ul>
</div>

*Filters* are used to manipulate text or as helper methods and are used with the pipe
characters (|).

{{ site.title | link_to: home_path }}

You have access to all of the liquid filters on "this page":liquid-designers as well as the ones described 
in the filters section below.

Again for more information on liquid see the "liquid wiki":liquid

h2. Filters

|_. name|_. meaning|
|link_to(title, target, params=nil)|Turns the title into a link to target maintaining the search params|
|blank_target_link(title, target, params)|Same as link_to except adds target='_blank' to the link in an attempt to open it in a new tab|
|link_with_sort(title, target, key, params)|Turns title into a link to target which toggles key as a sorting parameter|
|image_path(file_name, site)|Get the path to images uploaded to your theme using the file name and passing it the site|

h2. Variables

h3. All (Available to all pages)

|_. name|_. meaning|
|home_path|the path to the home page for your site|
|browse_path|the path to the browse page for your site|
|search_path|the path to the search page for your site|
|news_path|the path to the news page for your site|
|about_path|the path to the about page for your site|
|site|Your site as an object with attributes name, title, welcome_blurb, about_procedures, about_project|
|singular|the singular term for your artifacts|
|plural|the plural term for your artifacts|
|item_count|the number of artifacts in your site|
|image_count|the number of images in your site|
|media_count|the number of media files in your site|
|search_query_string|the query string from the current search. Used to help maintain search accross links|
|search_params|An object dump of the search parameters. Used strictly as a parameter to filters|


h3. Layout

|_. name|_. meaning|
|yield|the content of the template for the page. This sounds confusing but is not.  If the user navigates to the search page your template for the search page is rendered and put into the yeild variable|
|navigation|This just contains a simple html list of navigation links|
|breadcrumb|A trail of links to help know where you came from|
|sp_logo|The powered by streetprint logo|


h3. Home page

|_. name|_. meaning|
|item|the featured item for your site|
|image|the featured image for your site|

h3. About page

|_. name|_. meaning|
|posts|An array of all of your news posts|

h3. Show artifact page

|_. name|_. meaning|
|item|The artifact being displayed|
|photos|HTML to display the artifacts photos and allow viewing of all of them|
|next_prev_links|Next and previous links that link to the next/previous artifact obeying the current search context|

h3. Browse artifacts page

|_. name|_. meaning|
|browse_by_list|html list of browse by options|
|options_list|list of options for the browse that has been selected i.e. a list of categories (this is only set if a browse option with a suboptions list has been selected)|
|options|an array of the current options|

h3. Search artifacts page

|_. name|_. meaning|
|items|The first page of artifacts|
|seach_form|HTML search form used to search on artifacts|
|featured_item|The featured item for the site|
|pagination|Pagination links|

h3. Show author page

|_. name|_. meaning|
|author|The author to be displayed|

h3. Full text page

|_. name|_. meaning|
|item|the artifact the full text belongs to|
|full_text|The full_text to be displayed|

h3. Google location page

|_. name|_. meaning|
|item|The artifact of the location we are displaying|
|map|The map displaying the location|

[liquid]http://wiki.github.com/tobi/liquid
[liquid-designers]http://wiki.github.com/tobi/liquid/liquid-for-designers
  EOS
end
