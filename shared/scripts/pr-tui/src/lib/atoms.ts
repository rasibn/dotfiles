import { atom } from "jotai";

export type Focus = "main" | "sidebar";
export type ActiveTab = number;

export const focusAtom = atom<Focus>("main");
export const mainSearchingAtom = atom<boolean>(false);
export const sidebarSearchingAtom = atom<boolean>(false);
