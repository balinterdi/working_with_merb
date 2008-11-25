require 'dm-sweatshop'
User.fixture{{
	:login => 'one',
	:password => 'i_am_one',
	:password_confirmation => 'i_am_one'
}}

User.fixture(:joe) {{
	:login => 'joe',
	:password => 'let_joe_pass',
	:password_confirmation => 'let_joe_pass'	
}}
