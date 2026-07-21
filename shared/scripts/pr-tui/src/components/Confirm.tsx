import React from "react";
import { Box, Text, useInput } from "ink";
import { useAtomValue } from "jotai";
import { focusAtom, type Focus } from "../lib/atoms.js";

interface ConfirmProps {
  message: string;
  panel: Focus;
  onConfirm: () => void;
  onCancel: () => void;
}

export function Confirm({ message, panel, onConfirm, onCancel }: ConfirmProps) {
  const focus = useAtomValue(focusAtom);

  useInput(
    (input) => {
      if (input === "y") onConfirm();
      else onCancel();
    },
    { isActive: focus === panel },
  );

  return (
    <Box marginTop={1}>
      <Text color="red">{message} </Text>
      <Text color="yellow">y</Text>
      <Text color="gray">/</Text>
      <Text color="yellow">n</Text>
    </Box>
  );
}
