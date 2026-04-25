import { atom } from "jotai";
import { config } from "./config.js";

export type Focus = "main" | "sidebar";
export type ActiveTab = number;

export const focusAtom = atom<Focus>(config.defaultFocus);
export const mainSearchingAtom = atom<boolean>(false);
export const sidebarSearchingAtom = atom<boolean>(false);
