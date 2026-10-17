local M = {}

local notify, run

function M.open()
  if M.running then
    notify("Already looking up the PR base.")
    return
  end
  if vim.fn.executable("gh") ~= 1 then
    notify("Install GitHub CLI (gh) and run gh auth login first.", vim.log.levels.ERROR)
    return
  end

  M.running = true
  local cwd = vim.fn.getcwd()
  run({ "git", "rev-parse", "--show-toplevel" }, cwd, function(root)
    run({ "gh", "pr", "view", "--json", "baseRefName,baseRefOid,url" }, root, function(output)
      local ok, pr = pcall(vim.json.decode, output)
      local repo = ok and type(pr) == "table" and type(pr.url) == "string" and pr.url:match("^(https://.-)/pull/%d+")
      if not repo or type(pr.baseRefOid) ~= "string" or not pr.baseRefOid:match("^%x+$") then
        M.running = false
        notify("Could not determine the PR base repository and commit.", vim.log.levels.ERROR)
        return
      end

      notify("Fetching PR base: " .. pr.baseRefName)
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
end

notify = function(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "PR Review" })
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
