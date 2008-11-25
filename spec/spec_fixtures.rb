require 'dm-sweatshop'
User.fixture{{
	:login => 'iamone',
	:password => 'i_am_one',
	:password_confirmation => 'i_am_one',
	:email => 'one@one.com',
}}

User.fixture(:joe) {{
	:login => 'joe_smith',
	:password => 'let_joe_pass',
	:password_confirmation => 'let_joe_pass',
	:email => 'joe@joe.com',
	# :blog_url => 'http://joe.myname.com'
}}
