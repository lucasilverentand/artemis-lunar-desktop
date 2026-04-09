// @ts-check
import { defineConfig } from "astro/config";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  site: "https://lunar.lucasilverentand.com",
  base: "/",
  vite: {
    plugins: [tailwindcss()],
    define: {
      "import.meta.env.PUBLIC_IMAGE_BASE": JSON.stringify(
        "https://raw.githubusercontent.com/lucasilverentand/artemis-lunar-wallpapers/main/"
      ),
    },
  },
});
