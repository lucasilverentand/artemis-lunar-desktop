// @ts-check
import { defineConfig } from "astro/config";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  site: "https://lucasilverentand.github.io",
  base: "/artemis-lunar-desktop/",
  vite: {
    plugins: [tailwindcss()],
  },
});
