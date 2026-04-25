import React, { useState, useEffect, type ReactNode } from "react";
import { Box, Text, useInput } from "ink";
import { useAtom, useAtomValue } from "jotai";
import { focusAtom, mainSearchingAtom, sidebarSearchingAtom, type Focus } from "../lib/atoms.js";

interface SelectListProps<T> {
  panel: Focus;
  items: T[];
  searchValue: (item: T) => string;
  renderItem: (item: T, opts: { isCursor: boolean }) => ReactNode;
  onSelect?: (item: T) => void;
  onCreate?: (query: string) => void;
  onKeyAction?: (key: string, item: T) => void;
  disabled?: boolean;
  emptyText?: string;
  viewportSize?: number;
  itemLines?: number;
  scrollToTopSignal?: number;
}

export function SelectList<T>({
  panel,
  items,
  searchValue,
  renderItem,
  onSelect,
  onCreate,
  onKeyAction,
  disabled = false,
  emptyText = "No items",
  viewportSize = 20,
  itemLines = 1,
  scrollToTopSignal = 0,
}: SelectListProps<T>) {
  const focus = useAtomValue(focusAtom);
  const searchAtom = panel === "sidebar" ? sidebarSearchingAtom : mainSearchingAtom;
  const [searching, setSearching] = useAtom(searchAtom);
  const [query, setQuery] = useState("");
  const [cursor, setCursor] = useState(0);
  const [viewportStart, setViewportStart] = useState(0);

  const isActive = !disabled && focus === panel;

  const enterSearch = () => {
    setSearching(true);
    setQuery("");
  };
  const exitSearch = () => {
    setSearching(false);
  };

  useEffect(() => {
    if (!isActive && searching) {
      setSearching(false);
      setQuery("");
    }
  }, [isActive]);

  useEffect(() => {
    setCursor(0);
    setViewportStart(0);
  }, [query]);
  useEffect(() => {
    setCursor(0);
    setViewportStart(0);
  }, [scrollToTopSignal]);

  const filtered = query
    ? items.filter((item) => searchValue(item).toLowerCase().includes(query.toLowerCase()))
    : items;

  const clampedCursor = filtered.length === 0 ? -1 : Math.min(cursor, filtered.length - 1);

  const itemsPerViewport = Math.floor(viewportSize / itemLines);

  const moveTo = (index: number) => {
    const clamped = Math.max(0, Math.min(filtered.length - 1, index));
    setCursor(clamped);
    if (clamped < viewportStart) setViewportStart(clamped);
    else if (clamped >= viewportStart + itemsPerViewport)
      setViewportStart(clamped - itemsPerViewport + 1);
  };

  useInput(
    (input, key) => {
      if (!isActive) return;

      if (searching) {
        if (key.escape || key.return) {
          exitSearch();
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

      if (input === "j" || key.downArrow) {
        moveTo(clampedCursor + 1);
        return;
      }
      if (input === "k" || key.upArrow) {
        moveTo(clampedCursor - 1);
        return;
      }
      if (input === "g") {
        moveTo(0);
        return;
      }
      if (input === "G") {
        moveTo(filtered.length - 1);
        return;
      }
      if (input === "/") {
        enterSearch();
        return;
      }
      if (key.escape) {
        setQuery("");
        return;
      }
      if (key.return && clampedCursor >= 0 && onSelect) {
        onSelect(filtered[clampedCursor]!);
        return;
      }
      if (key.return && query && onCreate) {
        onCreate(query);
        setQuery("");
        return;
      }
      if (input && onKeyAction && clampedCursor >= 0) {
        onKeyAction(input, filtered[clampedCursor]!);
      }
    },
    { isActive },
  );

  const visible = filtered.slice(viewportStart, viewportStart + itemsPerViewport);

  return (
    <Box flexDirection="column">
      {searching && (
        <Box marginBottom={1}>
          <Text color="yellow">find: </Text>
          <Text color="magenta">{query}</Text>
          <Text color="yellow">_</Text>
        </Box>
      )}
      {!searching && query && (
        <Box marginBottom={1}>
          <Text color="yellow">find: </Text>
          <Text color="magenta">{query}</Text>
          <Text dimColor> (Esc to clear)</Text>
        </Box>
      )}
      {filtered.length === 0 ? (
        <Text dimColor>
          {query && onCreate
            ? `Press Enter to create "${query}"`
            : query
              ? `No matches for "${query}"`
              : emptyText}
        </Text>
      ) : (
        visible.map((item, i) => {
          const realIndex = viewportStart + i;
          const isCursor = realIndex === clampedCursor;
          return <Box key={realIndex}>{renderItem(item, { isCursor })}</Box>;
        })
      )}
      {filtered.length > itemsPerViewport && (
        <Text dimColor>
          [{viewportStart + 1}-{Math.min(viewportStart + itemsPerViewport, filtered.length)} of{" "}
          {filtered.length}]
        </Text>
      )}
    </Box>
  );
}
