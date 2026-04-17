import React, { createContext, useContext, useState, type ReactNode } from "react";

type InputMode = "normal" | "search";

interface InputModeContext {
  mode: InputMode;
  setMode: (mode: InputMode) => void;
}

const Context = createContext<InputModeContext>({ mode: "normal", setMode: () => {} });

export function InputModeProvider({ children }: { children: ReactNode }) {
  const [mode, setMode] = useState<InputMode>("normal");
  return <Context.Provider value={{ mode, setMode }}>{children}</Context.Provider>;
}

export function useInputMode() {
  return useContext(Context);
}
