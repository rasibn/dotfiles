import { useInput, type Key } from "ink";
import { useAtomValue } from "jotai";
import { mainSearchingAtom, sidebarSearchingAtom, type Focus } from "./atoms.js";

/**
 * Like ink's useInput, but automatically suppressed when the panel's
 * search mode is active.  Prevents every component from needing to
 * independently guard against search state.
 */
export function useGuardedInput(
  panel: Focus,
  handler: (input: string, key: Key) => void,
  opts: { isActive?: boolean } = {},
) {
  const searchAtom = panel === "main" ? mainSearchingAtom : sidebarSearchingAtom;
  const searching = useAtomValue(searchAtom);

  useInput(handler, {
    isActive: (opts.isActive ?? true) && !searching,
  });
}
