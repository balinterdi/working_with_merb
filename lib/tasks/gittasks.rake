namespace :git do
	desc "Commit and push to a repo"
	task :gitcipu do
		unless ENV.include?('msg') && !ENV['msg'].blank?
			raise "usage: git:gitcipu msg=<commit msg> [repos=<repo_to_push_to>]"
		end
		commit_msg = ENV['msg']
		repo_to_push_to = ENV['repos'].nil? ? 'origin' : ENV['repos']
		system(%(git commit -asm '#{commit_msg}'))
		system(%(git push #{repo_to_push_to} master))
	end
end