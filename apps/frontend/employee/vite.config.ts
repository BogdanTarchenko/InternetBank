import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'
import path from 'path'

const clientBankSrc = path.resolve(__dirname, '../client/src')

// Employee app shares entities & shared-layer from the client app via aliases.
// Own code (app, features, pages, widgets) lives in ./src
export default defineConfig({
  plugins: [react(), tailwindcss()],
  server: { port: 5174 },
  resolve: {
    alias: [
      // More-specific aliases must come first
      { find: '@/entities', replacement: path.join(clientBankSrc, 'entities') },
      { find: '@/shared',   replacement: path.join(clientBankSrc, 'shared') },
      { find: '@',          replacement: path.resolve(__dirname, 'src') },
    ],
  },
})
