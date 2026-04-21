import React from "react";
import { Box, Text } from "ink";

const TAB_LABELS = ["Open Local", "Open PRs"];

interface TabsProps {
  activeIndex: number;
}

export function Tabs({ activeIndex }: TabsProps) {
  return (
    <Box flexDirection="row" marginBottom={1}>
      {TAB_LABELS.map((label, i) => (
        <Box key={label} marginRight={1}>
          <Text
            bold={i === activeIndex}
            color={i === activeIndex ? "cyan" : "gray"}
            inverse={i === activeIndex}
          >
            {` ${label} `}
          </Text>
        </Box>
      ))}
      <Box flexGrow={1} />
      <Text dimColor>{"h/l tabs  j/k nav  / search  Tab sidebar  C-o repo  q quit"}</Text>
    </Box>
  );
}
