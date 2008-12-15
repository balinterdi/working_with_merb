namespace :git do
  desc "Commit and push to a repo in one step"
  task :gitcipu do
    unless ENV.include?('msg') && !ENV['msg'].blank?
      raise "usage: git:gitcipu msg=<commit msg> [repo=<remote_repos_to_push_to>] [branch=<local_branch_to_push>]"
    end
    commit_msg = ENV['msg']
    repo_to_push_to = ENV['repo'].nil? ? 'origin' : ENV['repo']
    local_branch = ENV['branch'].nil? ? 'master' : ENV['branch']
    system(%(git commit -asm '#{commit_msg}'))
    system(%(git push #{repo_to_push_to} #{local_branch}))
  end
end