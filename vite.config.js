import { defineConfig, loadEnv, transformWithOxc } from "vite"
import { coffee } from 'vite-plugin-coffee3'
import svgrPlugin from 'vite-plugin-svgr'
import { resolve } from 'path'

// coffee passes JSX through untransformed; convert it here
// https://github.com/vitejs/vite/discussions/21505#discussioncomment-15706402
const transformJsxInCoffee = () => ({
  name: "transform-jsx-in-coffee",
  enforce: "pre",
  async transform(code, id) {
    if (!id.match(/.*\.(coffee|js|jsx|ts|tsx)$/)) {
      return null;
    }
    return await transformWithOxc(code, id, {
      lang: "jsx",
    });
  },
});

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '')

  return {
    plugins: [
      {...coffee(), enforce: 'pre'},
      transformJsxInCoffee(),
      svgrPlugin({ svgrOptions: { svgo: false } }),
      {
        name: 'coffee-module',
        configureServer(server) {
          server.middlewares.use((req, res, next) => {
            if (req.url.endsWith('.coffee')) {
              req.url += '?import'
            }
            next()
          })
        }
      }
    ],
    define: {
      'process.env.NODE_ENV': JSON.stringify(mode),
      'process.env.SENTRY_DSN_FRONTEND': JSON.stringify(env.SENTRY_DSN_FRONTEND ?? ''),
    },
    css: {
      preprocessorOptions: {
        sass: {
          loadPaths: [resolve(__dirname, 'styles')],
          // like the old .sassrc.js: inject variables into every stylesheet
          additionalData: (src, filename) =>
            filename.endsWith('variables.sass') ? src : "@import 'variables'\n" + src,
          silenceDeprecations: ['import'],
        },
      },
    },
    resolve: {
      extensions: ['.coffee', '.mjs', '.js', '.jsx', '.ts', '.tsx', '.json', '.sass', '.css'],
      alias: {
        '/': resolve(__dirname, '.'),
      },
    },
    server: {
      port: 1234,
      allowedHosts: true,
      proxy: {
        '/riding_for': {
          target: process.env.VITE_API_PROXY_TARGET || 'https://api.votewell.local',
          changeOrigin: true,
          secure: false,
          rewrite: (path) => path.replace(/^\/riding_for/, '')
        }
      }

    },
  }
})
