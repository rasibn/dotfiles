import React, { useState, useEffect } from "react";
import { Box, Text } from "ink";
import { SelectList } from "./SelectList.js";
import { discoverRepos, type Repo } from "../lib/repos.js";

interface RepoPickerProps {
  onSelect: (path: string) => void;
}

export function RepoPicker({ onSelect }: RepoPickerProps) {
  const [repos, setRepos] = useState<Repo[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    discoverRepos().then((r) => {
      setRepos(r);
      setLoading(false);
    });
  }, []);

  if (loading) {
    return (
      <Box flexDirection="column" paddingX={1}>
        <Text color="yellow">Scanning for repositories...</Text>
      </Box>
    );
  }

  if (repos.length === 0) {
    return (
      <Box flexDirection="column" paddingX={1}>
        <Text color="red">No git repos found.</Text>
        <Text dimColor>
          Set $PROJECT_DIR, $WORK_DIR, or $ASSET_DIR, or pass a repo path: prtui /path/to/repo
        </Text>
      </Box>
    );
  }

  return (
    <Box flexDirection="column" paddingX={1}>
      <Box marginBottom={1}>
        <Text bold>Select a repository</Text>
        <Text dimColor> j/k nav / search Enter select</Text>
      </Box>
      <SelectList
        items={repos}
        active={true}
        searchValue={(r) => `${r.name} ${r.path}`}
        onSelect={(r) => onSelect(r.path)}
        emptyText="No git repos found"
        renderItem={(repo, { isCursor }) => (
          <>
            <Text color={isCursor ? "cyan" : undefined} bold={isCursor}>
              {isCursor ? "> " : "  "}
            </Text>
            <Text color={isCursor ? "cyan" : undefined} bold={isCursor}>
              {repo.name}
            </Text>
            <Text dimColor> {repo.path}</Text>
          </>
        )}
      />
    </Box>
  );
}
