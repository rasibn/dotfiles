import { useState, useCallback } from "react";
import { useInput } from "ink";

interface UseVimNavOptions {
  length: number;
  active?: boolean;
  viewportSize?: number;
}

export function useVimNav({ length, active = true, viewportSize = 20 }: UseVimNavOptions) {
  const [cursor, setCursor] = useState(0);
  const [viewportStart, setViewportStart] = useState(0);

  const moveTo = useCallback(
    (index: number) => {
      const clamped = Math.max(0, Math.min(length - 1, index));
      setCursor(clamped);

      // Adjust viewport
      if (clamped < viewportStart) {
        setViewportStart(clamped);
      } else if (clamped >= viewportStart + viewportSize) {
        setViewportStart(clamped - viewportSize + 1);
      }
    },
    [length, viewportStart, viewportSize],
  );

  useInput(
    (input, key) => {
      if (!active || length === 0) return;

      if (input === "j" || (key.ctrl && input === "n") || (key.ctrl && input === "j")) {
        moveTo(cursor + 1);
      } else if (input === "k" || (key.ctrl && input === "p") || (key.ctrl && input === "k")) {
        moveTo(cursor - 1);
      } else if (input === "g" && !key.ctrl) {
        moveTo(0);
      } else if (input === "G") {
        moveTo(length - 1);
      }
    },
    { isActive: active },
  );

  // Reset cursor when list length changes
  if (cursor >= length && length > 0) {
    setCursor(length - 1);
  }

  return {
    cursor: length === 0 ? -1 : cursor,
    viewportStart,
    viewportEnd: Math.min(viewportStart + viewportSize, length),
  };
}
