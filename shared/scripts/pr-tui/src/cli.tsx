import React from "react";
import { render } from "ink";
import { Provider } from "jotai";
import { App } from "./app.js";
import { isInsideTmux } from "./lib/tmux.js";
if (!isInsideTmux()) {
  console.error("prtui must be run inside tmux.");
  console.error("Start a tmux session first: tmux new -s manager 'prtui'");
  process.exit(1);
}

const cwd = process.argv[2] || process.cwd();

process.stdout.write("\x1b[?1049h");
process.stdout.write("\x1b[H");

const { waitUntilExit } = render(
  <Provider>
    <App cwd={cwd} />
  </Provider>,
);

waitUntilExit().then(() => {
  process.stdout.write("\x1b[?1049l");
});
