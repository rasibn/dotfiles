import React, { useState, useEffect, type ReactNode } from "react";
import { Box, Text, useInput } from "ink";
import { useInputMode } from "../lib/input-mode.js";

interface SelectListProps<T> {
  items: T[];
  active: boolean;
  searchValue: (item: T) => string;
  renderItem: (item: T, opts: { isCursor: boolean; isSelected: boolean }) => ReactNode;
  onSelect?: (item: T) => void;
  onConfirm?: (items: T[]) => void;
  multiSelect?: boolean;
  emptyText?: string;
  viewportSize?: number;
}

export function SelectList<T>({
  items,
  active,
  searchValue,
  renderItem,
  onSelect,
  onConfirm,
  multiSelect = false,
  emptyText = "No items",
  viewportSize = 20,
}: SelectListProps<T>) {
  const { mode, setMode } = useInputMode();
  const searching = mode === "search";

  const [query, setQuery] = useState("");
  const [cursor, setCursor] = useState(0);
  const [viewportStart, setViewportStart] = useState(0);
  const [selected, setSelected] = useState<Set<number>>(new Set());

  const filtered = query
    ? items.filter((item) => searchValue(item).toLowerCase().includes(query.toLowerCase()))
    : items;

  useEffect(() => {
    setCursor(0);
    setViewportStart(0);
  }, [query]);

  useEffect(() => {
    setQuery("");
    setSelected(new Set());
    setCursor(0);
    setViewportStart(0);
  }, [items]);

  const clampedCursor = filtered.length === 0 ? -1 : Math.min(cursor, filtered.length - 1);

  const moveTo = (index: number) => {
    const clamped = Math.max(0, Math.min(filtered.length - 1, index));
    setCursor(clamped);
    if (clamped < viewportStart) {
      setViewportStart(clamped);
    } else if (clamped >= viewportStart + viewportSize) {
      setViewportStart(clamped - viewportSize + 1);
    }
  };

  const toggleSelect = (index: number) => {
    setSelected((prev) => {
      const next = new Set(prev);
      const originalIndex = items.indexOf(filtered[index]!);
      if (next.has(originalIndex)) {
        next.delete(originalIndex);
      } else {
        next.add(originalIndex);
      }
      return next;
    });
  };

  useInput(
    (input, key) => {
      if (searching) {
        if (key.escape) {
          setMode("normal");
          return;
        }
        if (key.return) {
          setMode("normal");
          return;
        }
        if (key.backspace || key.delete) {
          setQuery((q) => q.slice(0, -1));
          return;
        }
        if (input && !key.ctrl && !key.meta) {
          setQuery((q) => q + input);
        }
        return;
      }

      if (input === "j") {
        moveTo(clampedCursor + 1);
      } else if (input === "k") {
        moveTo(clampedCursor - 1);
      } else if (input === "g") {
        moveTo(0);
      } else if (input === "G") {
        moveTo(filtered.length - 1);
      } else if (input === "/") {
        setMode("search");
        setQuery("");
      } else if (key.escape) {
        setQuery("");
      } else if (key.tab && multiSelect && clampedCursor >= 0) {
        toggleSelect(clampedCursor);
      } else if (input === " " && multiSelect && clampedCursor >= 0) {
        toggleSelect(clampedCursor);
      } else if (key.return && clampedCursor >= 0) {
        if (multiSelect && onConfirm) {
          const selectedItems = [...selected].map((i) => items[i]!).filter(Boolean);
          if (selectedItems.length > 0) {
            onConfirm(selectedItems);
          }
        } else if (onSelect) {
          onSelect(filtered[clampedCursor]!);
        }
      }
    },
    { isActive: active },
  );

  const visible = filtered.slice(viewportStart, viewportStart + viewportSize);

  return (
    <Box flexDirection="column">
      {searching && (
        <Box marginBottom={1}>
          <Text color="yellow">{"find: "}</Text>
          <Text color="cyan">{query}</Text>
          <Text color="yellow">_</Text>
        </Box>
      )}
      {!searching && query && (
        <Box marginBottom={1}>
          <Text color="yellow">{"find: "}</Text>
          <Text color="cyan">{query}</Text>
          <Text dimColor> (Esc to clear)</Text>
        </Box>
      )}

      {filtered.length === 0 ? (
        <Text dimColor>{query ? `No matches for "${query}"` : emptyText}</Text>
      ) : (
        visible.map((item, i) => {
          const realIndex = viewportStart + i;
          const isCursor = realIndex === clampedCursor;
          const originalIndex = items.indexOf(item);
          const isSelected = selected.has(originalIndex);
          return <Box key={realIndex}>{renderItem(item, { isCursor, isSelected })}</Box>;
        })
      )}

      {filtered.length > viewportSize && (
        <Text dimColor>
          [{viewportStart + 1}-{Math.min(viewportStart + viewportSize, filtered.length)} of{" "}
          {filtered.length}]
        </Text>
      )}
    </Box>
  );
}
