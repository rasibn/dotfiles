import React, { useState, useEffect } from "react";
import { Box, Text, useInput, useApp } from "ink";
import { useAtom, useAtomValue } from "jotai";
import { focusAtom, mainSearchingAtom, sidebarSearchingAtom } from "./lib/atoms.js";
import { Tabs } from "./components/Tabs.js";
import { Sessions } from "./components/Sessions.js";
import { PrList } from "./components/PrList.js";
import { BranchList } from "./components/BranchList.js";
import { RepoPicker } from "./components/RepoPicker.js";
import { getRepoRoot } from "./lib/git.js";
import { config } from "./lib/config.js";

interface AppProps {
  cwd: string;
}

const TAB_COUNT = 2;

export function App({ cwd: initialCwd }: AppProps) {
  const [focus, setFocus] = useAtom(focusAtom);
  const mainSearching = useAtomValue(mainSearchingAtom);
  const sidebarSearching = useAtomValue(sidebarSearchingAtom);
  const searching = mainSearching || sidebarSearching;
  const [activeTab, setActiveTab] = useState(0);
  const [repoCwd, setRepoCwd] = useState<string | null>(null);
  const [picking, setPicking] = useState(false);
  const [checking, setChecking] = useState(true);
  const [termRows, setTermRows] = useState(process.stdout.rows ?? 24);
  const [termCols, setTermCols] = useState(process.stdout.columns ?? 80);
  const [expanded, setExpanded] = useState(false);
  const { exit } = useApp();

  useEffect(() => {
    const onResize = () => {
      setTermRows(process.stdout.rows ?? 24);
      setTermCols(process.stdout.columns ?? 80);
    };
    process.stdout.on("resize", onResize);
    return () => {
      process.stdout.off("resize", onResize);
    };
  }, []);

  useEffect(() => {
    const root = getRepoRoot(initialCwd);
    if (root) setRepoCwd(root);
    else setPicking(true);
    setChecking(false);
  }, [initialCwd]);

  useInput((input, key) => {
    if (searching) return;

    if (key.tab) {
      setFocus((f) => (f === "main" ? "sidebar" : "main"));
      return;
    }
    if (input === "f") {
      setExpanded((e) => !e);
      return;
    }
    if (input === "q") {
      exit();
      return;
    }
    if (key.ctrl && input === "o") {
      setPicking(true);
      return;
    }

    if (focus === "main" && !picking) {
      if (input === "h" || key.leftArrow) setActiveTab((t) => Math.max(0, t - 1));
      if (input === "l" || key.rightArrow) setActiveTab((t) => Math.min(TAB_COUNT - 1, t + 1));
    }
  });

  const repoName = repoCwd ? repoCwd.split("/").pop() || repoCwd : null;

  const renderMain = () => {
    if (checking) return <Text color="yellow">Checking repository...</Text>;
    if (picking)
      return (
        <RepoPicker
          onSelect={(path) => {
            setRepoCwd(path);
            setPicking(false);
            setActiveTab(0);
          }}
        />
      );
    if (!repoCwd) return <Text color="red">No repository selected. Press Ctrl+o to pick one.</Text>;
    return (
      <>
        <Tabs activeIndex={activeTab} />
        {activeTab === 0 && <BranchList cwd={repoCwd} />}
        {activeTab === 1 && <PrList cwd={repoCwd} />}
      </>
    );
  };

  const vertical = termCols < config.verticalBreakpoint;
  const sidebarHeight = vertical ? Math.floor(termRows / 2) : termRows - 1;
  const mainHeight = vertical ? termRows - 1 - sidebarHeight : termRows - 1;
  const sidebarExpanded = expanded && focus === "sidebar";
  const mainExpanded = expanded && focus === "main";

  return (
    <Box flexDirection="column" paddingX={1}>
      <Box flexDirection={vertical ? "column" : "row"}>
        {!mainExpanded && (
          <Box
            flexDirection="column"
            width={sidebarExpanded ? termCols - 2 : vertical ? undefined : config.sidebarWidth}
            minWidth={sidebarExpanded ? termCols - 2 : vertical ? undefined : config.sidebarWidth}
            height={sidebarHeight}
            marginRight={vertical || sidebarExpanded ? 0 : 1}
            flexShrink={0}
            flexGrow={0}
            borderStyle="single"
            borderColor={focus === "sidebar" ? "magenta" : "gray"}
          >
            <Box paddingX={1}>
              <Text bold color={focus === "sidebar" ? "magenta" : "gray"}>
                Active Sessions
              </Text>
            </Box>
            <Box paddingX={1} overflow="hidden">
              <Sessions cwd={repoCwd} expanded={sidebarExpanded} />
            </Box>
          </Box>
        )}
        {!sidebarExpanded && (
          <Box
            flexDirection="column"
            flexGrow={1}
            height={mainHeight}
            borderStyle="single"
            borderColor={focus === "main" ? "magenta" : "gray"}
          >
            {repoName && (
              <Box paddingX={1}>
                <Text dimColor>repo: </Text>
                <Text color="green" bold>
                  {repoName}
                </Text>
                <Text dimColor> (Ctrl+o to switch)</Text>
              </Box>
            )}
            <Box paddingX={1} flexDirection="column" flexGrow={1}>
              {renderMain()}
            </Box>
            <Box paddingX={1}>
              <Text dimColor>
                {picking
                  ? "j/k nav / search ↵ select q quit"
                  : "h/l tabs j/k nav / search ↵ open Tab sidebar C-o repo f expand q quit"}
              </Text>
            </Box>
          </Box>
        )}
      </Box>
    </Box>
  );
}
