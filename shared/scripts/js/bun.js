import { $ } from 'bun';

try {
  const result = await $`nano bun.js`.text();
  console.log("result: ", result)
} catch (error) {
  console.log(error)
}
