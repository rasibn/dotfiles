import { useState, useCallback } from "react";
import { useInput } from "ink";

interface UseMultiSelectOptions {
  active?: boolean;
}

export function useMultiSelect({ active = true }: UseMultiSelectOptions = {}) {
  const [selected, setSelected] = useState<Set<number>>(new Set());

  const toggle = useCallback((index: number) => {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(index)) {
        next.delete(index);
      } else {
        next.add(index);
      }
      return next;
    });
  }, []);

  const clear = useCallback(() => {
    setSelected(new Set());
  }, []);

  useInput(
    (input, key) => {
      // Tab and Space are handled by the parent component passing cursor index
      // This hook just manages the state
    },
    { isActive: active },
  );

  return { selected, toggle, clear };
}
