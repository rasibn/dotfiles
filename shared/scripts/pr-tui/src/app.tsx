import React, { useState } from "react";
import { Box, useInput, useApp } from "ink";
import { Tabs } from "./components/Tabs.js";
import { BranchList } from "./components/BranchList.js";
import { PrList } from "./components/PrList.js";
import { CleanUp } from "./components/CleanUp.js";

interface AppProps {
  cwd: string;
}

const TAB_COUNT = 3;

export function App({ cwd }: AppProps) {
  const [activeTab, setActiveTab] = useState(0);
  const { exit } = useApp();

  useInput((input, _key) => {
    if (input === "{" || input === "h") {
      setActiveTab((t) => Math.max(0, t - 1));
    } else if (input === "}" || input === "l") {
      setActiveTab((t) => Math.min(TAB_COUNT - 1, t + 1));
    } else if (input === "q") {
      exit();
    }
  });

  return (
    <Box flexDirection="column" paddingX={1}>
      <Tabs activeIndex={activeTab} />
      {activeTab === 0 && <BranchList cwd={cwd} active={activeTab === 0} />}
      {activeTab === 1 && <PrList cwd={cwd} active={activeTab === 1} />}
      {activeTab === 2 && <CleanUp cwd={cwd} active={activeTab === 2} />}
    </Box>
  );
}
