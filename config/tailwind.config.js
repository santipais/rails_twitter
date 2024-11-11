const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
      colors: {
        dark: {
          900: "#0F1419",
          800: "#17202A",
          700: "#1C2733",
          600: "#283340",
          500: "#3A444C",
          400: "#5B7083",
          300: "#8899A6",
          200: "#EBEEF0",
          100: "#F7F9FA",
        },
        primary: "#1DA1F2",
        "primary-dark": "#1A91DA",
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
  safelist: ['field_with_errors']
};
