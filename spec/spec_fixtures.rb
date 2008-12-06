require 'dm-sweatshop'



User.fixture(:james){{
	:login => 'james_duncan',
	:password => 'james_secret',
	:password_confirmation => 'james_secret',
	:email => 'james@email.org',
	:name  => 'James Duncan'
}}

User.fixture(:joe) {{
	:login => 'joe_smith',
	:password => 'let_joe_pass',
	:password_confirmation => 'let_joe_pass',
	:email => 'joe@joe.com',
	:name => 'Joe D. Smith'
	# :blog_url => 'http://joe.myname.com'
}}

User.fixture(:admin) {{
	:login => 'admin',
	:password => 'admin_secret',
	:password_confirmation => 'admin_secret',
	:email => 'console@linux.org',
	:name  => 'Admin User',
	:role => "admin",  
}}
