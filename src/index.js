export function main() {
  console.log("hello from crossplatform-app-starter");
  return true;
}

if (import.meta.url === `file://${process.argv[1]}`) main();
