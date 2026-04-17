import React from "react";
import { render } from "ink";
import { App } from "./app.js";
import { InputModeProvider } from "./lib/input-mode.js";

const cwd = process.argv[2] || process.cwd();

render(
  <InputModeProvider>
    <App cwd={cwd} />
  </InputModeProvider>,
);
