#!/usr/bin/env ruby

require "json"
require "octokit"
 
pr_number = ENV["PR_NUMBER"] || ""

github = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])

if !ENV["GITHUB_TOKEN"]
  puts "Missing GITHUB_TOKEN"
  exit(1)
end

if ARGV[0].empty?
  puts "Missing message argument."
  exit(1)
end

if pr_number.empty?
  puts "This is not a pull request deployment."
  exit(0)
end

message = ARGV[0]
check_duplicate_msg = ARGV[1]
repo = ENV.fetch("REPOSITRY")
username = ENV.fetch("USERNAME")

pulls = github.pull_request(repo, pr_number, state: "open")

if !pulls
  puts "Couldn't find an open pull request for branch."
  exit(1)
end

if pulls['state'] != "open"
  puts "Pull request has been closed."
  exit(1)
end

coms = github.issue_comments(repo, pr_number)

if check_duplicate_msg == "true"
  puts "Check user #{username}."
  duplicate = coms.find { |c| c["user"]["login"] == username && c["body"] == message }
  puts duplicate
  if duplicate
    puts "The PR already contains this message"
    exit(0)
  end
end

puts "Create comment: #{message}."
github.add_comment(repo, pr_number, message)