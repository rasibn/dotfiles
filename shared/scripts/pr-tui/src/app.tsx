import React, { useState, useEffect } from "react";
import { Box, Text, useInput, useApp } from "ink";
import { Tabs } from "./components/Tabs.js";
import { BranchList } from "./components/BranchList.js";
import { PrList } from "./components/PrList.js";
import { CleanUp } from "./components/CleanUp.js";
import { RepoPicker } from "./components/RepoPicker.js";
import { getRepoRoot } from "./lib/git.js";
import { useInputMode } from "./lib/input-mode.js";

interface AppProps {
  cwd: string;
}

const TAB_COUNT = 3;

export function App({ cwd: initialCwd }: AppProps) {
  const [activeTab, setActiveTab] = useState(0);
  const [repoCwd, setRepoCwd] = useState<string | null>(null);
  const [picking, setPicking] = useState(false);
  const [checking, setChecking] = useState(true);
  const { mode } = useInputMode();
  const { exit } = useApp();

  useEffect(() => {
    getRepoRoot(initialCwd).then((root) => {
      if (root) {
        setRepoCwd(root);
      } else {
        setPicking(true);
      }
      setChecking(false);
    });
  }, [initialCwd]);

  useInput(
    (input, key) => {
      if (picking || mode === "search") return;

      if (input === "h" || key.leftArrow) {
        setActiveTab((t) => Math.max(0, t - 1));
      } else if (input === "l" || key.rightArrow) {
        setActiveTab((t) => Math.min(TAB_COUNT - 1, t + 1));
      } else if (input === "q") {
        exit();
      } else if (key.ctrl && input === "o") {
        setPicking(true);
      }
    },
    { isActive: !picking },
  );

  if (checking) {
    return (
      <Box paddingX={1}>
        <Text color="yellow">Checking repository...</Text>
      </Box>
    );
  }

  if (picking) {
    return (
      <RepoPicker
        onSelect={(path) => {
          setRepoCwd(path);
          setPicking(false);
          setActiveTab(0);
        }}
      />
    );
  }

  if (!repoCwd) {
    return (
      <Box paddingX={1}>
        <Text color="red">No repository selected. Press Ctrl+o to pick one.</Text>
      </Box>
    );
  }

  const repoName = repoCwd.split("/").pop() || repoCwd;

  return (
    <Box flexDirection="column" paddingX={1}>
      <Box marginBottom={0}>
        <Text dimColor>repo: </Text>
        <Text color="green" bold>
          {repoName}
        </Text>
        <Text dimColor> (Ctrl+o to switch)</Text>
      </Box>
      <Tabs activeIndex={activeTab} />
      {activeTab === 0 && <BranchList cwd={repoCwd} active={activeTab === 0} />}
      {activeTab === 1 && <PrList cwd={repoCwd} active={activeTab === 1} />}
      {activeTab === 2 && <CleanUp cwd={repoCwd} active={activeTab === 2} />}
    </Box>
  );
}
