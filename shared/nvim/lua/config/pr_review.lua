local M = {}

local notify, run

function M.open()
  if M.running then
    notify("Already looking up pull requests for this branch.")
    return
  end
  if vim.fn.executable("gh") ~= 1 then
    notify("Install GitHub CLI (gh) and run gh auth login first.", vim.log.levels.ERROR)
    return
  end

  M.running = true
  local cwd = vim.fn.getcwd()
  run({ "git", "rev-parse", "--show-toplevel" }, cwd, function(root)
    run({ "git", "branch", "--show-current" }, root, function(branch)
      if branch == "" then
        M.running = false
        notify("Check out a branch before reviewing its PR.", vim.log.levels.ERROR)
        return
      end

      run({ "gh", "repo", "view", "--json", "defaultBranchRef", "--jq", ".defaultBranchRef.name" }, root, function(default_branch)
        if default_branch == "" then
          M.running = false
          notify("Could not determine the repository's default branch.", vim.log.levels.ERROR)
          return
        end

        run({
          "gh",
          "pr",
          "list",
          "--head",
          branch,
          "--state",
          "all",
          "--limit",
          "1000",
          "--json",
          "number,title,state,headRefName,baseRefName,baseRefOid,url",
        }, root, function(output)
          local ok, prs = pcall(vim.json.decode, output)
          if not ok or type(prs) ~= "table" then
            M.running = false
            notify("Could not read the pull requests for branch " .. branch .. ".", vim.log.levels.ERROR)
            return
          end

          prs = vim.tbl_filter(function(pr)
            return pr.headRefName ~= default_branch
          end, prs)
          if #prs == 0 then
            M.running = false
            notify("No non-default-branch pull requests found for branch " .. branch .. ".")
            return
          end

          Snacks.picker.select(prs, {
            prompt = "Review PR for " .. branch,
            format_item = function(pr)
              return ("#%d [%s → %s] %s (%s)"):format(pr.number, pr.state, branch, pr.title, pr.baseRefName)
            end,
          }, function(pr)
            if not pr then
              M.running = false
              return
            end

            local repo = type(pr.url) == "string" and pr.url:match("^(https://.-)/pull/%d+")
            if not repo or type(pr.baseRefOid) ~= "string" or not pr.baseRefOid:match("^%x+$") then
              M.running = false
              notify("Could not determine the PR base repository and commit.", vim.log.levels.ERROR)
              return
            end

            notify(("Fetching base for PR #%d: %s"):format(pr.number, pr.baseRefName))
            -- Fetch from the PR's target repository, including when this checkout is a fork.
            run({ "git", "fetch", "--no-tags", repo .. ".git", pr.baseRefOid }, root, function()
              M.running = false
              if vim.fn.getcwd() ~= cwd then
                -- Diffview resolves its repository from the current working directory.
                notify("Working directory changed. Open the repository root and try again.", vim.log.levels.WARN)
                return
              end
              local opened, err = pcall(vim.cmd, {
                cmd = "DiffviewOpen",
                args = { pr.baseRefOid .. "...HEAD", "--imply-local" },
              })
              if not opened then
                notify(tostring(err), vim.log.levels.ERROR)
              end
            end)
          end)
        end)
      end)
    end)
  end)
end

function M.open_commit()
  if M.running then
    notify("Already preparing a review.")
    return
  end

  M.running = true
  local cwd = vim.fn.getcwd()
  run({ "git", "rev-parse", "--show-toplevel" }, cwd, function(root)
    run({ "git", "rev-parse", "--verify", "HEAD^" }, root, function(parent)
      M.running = false
      if vim.fn.getcwd() ~= cwd then
        notify("Working directory changed. Open the repository root and try again.", vim.log.levels.WARN)
        return
      end

      local opened, err = pcall(vim.cmd, {
        cmd = "DiffviewOpen",
        args = { parent .. "..HEAD" },
      })
      if not opened then
        notify(tostring(err), vim.log.levels.ERROR)
      end
    end)
  end)
end

notify = function(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "Code Review" })
end

run = function(args, cwd, callback)
  vim.system(
    args,
    { cwd = cwd, text = true },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        M.running = false
        notify(
          vim.trim(result.stderr or "") ~= "" and vim.trim(result.stderr) or "Command failed: " .. args[1],
          vim.log.levels.ERROR
        )
        return
      end
      callback(vim.trim(result.stdout or ""))
    end)
  )
end

return M
