import React, { useState, useEffect } from "react";
import { Box, Text } from "ink";
import { SelectList } from "./SelectList.js";
import { discoverRepos, type Repo } from "../lib/repos.js";

const SIDEBAR_WIDTH = 47;

function truncatePath(path: string, maxLen: number): string {
  if (path.length <= maxLen) return path;
  return "…" + path.slice(path.length - maxLen + 1);
}

interface RepoPickerProps {
  onSelect: (path: string) => void;
}

export function RepoPicker({ onSelect }: RepoPickerProps) {
  const [repos, setRepos] = useState<Repo[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    discoverRepos().then((r) => { setRepos(r); setLoading(false); });
  }, []);

  if (loading) return <Text color="yellow">Scanning for repositories...</Text>;

  if (repos.length === 0) return (
    <Box flexDirection="column">
      <Text color="red">No git repos found.</Text>
      <Text dimColor>Set $PROJECT_DIR, $WORK_DIR, or $ASSET_DIR, or pass a repo path: prtui /path/to/repo</Text>
    </Box>
  );

  return (
    <Box flexDirection="column">
      <Box marginBottom={1}>
        <Text bold>Select a repository</Text>
        <Text dimColor> j/k nav / search Enter select</Text>
      </Box>
      <SelectList
        panel="picker"
        items={repos}
        searchValue={(r) => `${r.name} ${r.path}`}
        onSelect={(r) => onSelect(r.path)}
        emptyText="No git repos found"
        renderItem={(repo, { isCursor }) => {
          const cols = process.stdout.columns ?? 120;
          const maxPath = cols - SIDEBAR_WIDTH - 2 - 2 - 1 - repo.name.length - 1;
          const path = truncatePath(repo.path, Math.max(10, maxPath));
          return (
            <>
              <Text color={isCursor ? "cyan" : undefined} bold={isCursor}>{isCursor ? "> " : "  "}</Text>
              <Text color={isCursor ? "cyan" : undefined} bold={isCursor}>{repo.name}</Text>
              <Text dimColor> {path}</Text>
            </>
          );
        }}
      />
    </Box>
  );
}
