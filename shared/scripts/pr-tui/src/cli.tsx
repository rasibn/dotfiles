import React from "react";
import { render } from "ink";
import { App } from "./app.js";
import { InputModeProvider } from "./lib/input-mode.js";
import { isInsideTmux } from "./lib/tmux.js";

if (!isInsideTmux()) {
  console.error("prtui must be run inside tmux.");
  console.error("Start a tmux session first: tmux new -s manager 'prtui'");
  process.exit(1);
}

const cwd = process.argv[2] || process.cwd();

render(
  <InputModeProvider>
    <App cwd={cwd} />
  </InputModeProvider>,
);
