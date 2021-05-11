colors = require '../data/colors.json'

for k, v of colors
  colors[k] =
    r: v.rgb[0]
    g: v.rgb[1]
    b: v.rgb[2]

module.exports = Object.assign colors,
  black: {r: 0, g:0, b:0, a:0, w:0, uv:0}
  red: {r: 255, g:0, b:0, a:0, w:0, uv:0}
  green: {r: 0, g:255, b:0, a:0, w:0, uv:0}
  blue: {r: 0, g:0, b:255, a:0, w:0, uv:0}
  yellow: {r: 255, g:127, b:0, a:0, w:0, uv:0}
  cyan: {r: 0, g:255, b:255, a:0, w:0, uv:0}
  uv: {r: 0, g:0, b:0, a:0, w:0, uv:255}

  purple: {r: 255, g:0, b:255, a:0, w:0, uv:0}
  violet: {r:20, b: 10, g: 0, w: 0, a:0, uv: 255}
  darkPurple: {r: 50, g:0, b:50, a:0, w:0, uv:255}
  darkPink: {r: 255, g:0, b:0, a:0, w:0, uv:255}

  pinkWhite: {r: 255, g:127, b:64, a:30, w:0, uv:0}
  softWhite: {r: 255, g:120, b:0, a:37, w:72, uv:0}
  goldWhite: {r: 255, g:127, b:0, a:36, w:72, uv:0}
  goldDeep: {r: 255, g:109, b:0, a:64, w:0, uv:64}
