import tailwindcss from '@tailwindcss/vite'
import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss()],
  server: {
    host: '0.0.0.0',
    port: 5173,
    strictPort: true,
    // Le code est monté en volume Docker : le polling fiabilise le HMR
    // (notamment sous WSL2 / macOS où les événements inotify ne passent pas).
    watch: { usePolling: true },
  },
})
