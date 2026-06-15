import test from "node:test";
import assert from "node:assert/strict";
import { main } from "./index.js";

test("main runs", () => {
  assert.equal(main(), true);
});
